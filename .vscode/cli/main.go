package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"time"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type ChatRequest struct {
	Model    string    `json:"model"`
	Messages []Message `json:"messages"`
	Stream   bool      `json:"stream"`
}

type ChatResponse struct {
	Model     string  `json:"model"`
	Message   Message `json:"message"`
	Done      bool    `json:"done"`
	CreatedAt string  `json:"created_at"`
}

type ConversationEntry struct {
	ID        string    `json:"id"`
	Timestamp time.Time `json:"timestamp"`
	Prompt    string    `json:"prompt"`
	Response  string    `json:"response"`
	Model     string    `json:"model"`
}

type Server struct {
	ollamaURL string
	dataDir   string
}

var (
	conversations map[string][]ConversationEntry
)

func init() {
	conversations = make(map[string][]ConversationEntry)
}

func (s *Server) streamToOllama(model string, messages []Message) (string, error) {
	reqBody := ChatRequest{
		Model:    model,
		Messages: messages,
		Stream:   true,
	}

	jsonBody, _ := json.Marshal(reqBody)
	resp, err := http.Post(
		fmt.Sprintf("%s/api/chat", s.ollamaURL),
		"application/json",
		bytes.NewBuffer(jsonBody),
	)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var fullResponse string
	decoder := json.NewDecoder(resp.Body)
	for {
		var chatResp ChatResponse
		if err := decoder.Decode(&chatResp); err != nil {
			if err == io.EOF {
				break
			}
			return "", err
		}
		fullResponse += chatResp.Message.Content
	}

	return fullResponse, nil
}

func (s *Server) chat(c *gin.Context) {
	var req struct {
		Model       string   `json:"model"`
		Prompt      string   `json:"prompt"`
		SystemPrompt string  `json:"system_prompt"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	messages := []Message{}
	if req.SystemPrompt != "" {
		messages = append(messages, Message{
			Role:    "system",
			Content: req.SystemPrompt,
		})
	}
	messages = append(messages, Message{
		Role:    "user",
		Content: req.Prompt,
	})

	response, err := s.streamToOllama(req.Model, messages)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, gin.H{
		"response": response,
		"model":    req.Model,
	})
}

func (s *Server) chatStream(c *gin.Context) {
	var req struct {
		Model        string `json:"model"`
		Prompt       string `json:"prompt"`
		SystemPrompt string `json:"system_prompt"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	messages := []Message{}
	if req.SystemPrompt != "" {
		messages = append(messages, Message{
			Role:    "system",
			Content: req.SystemPrompt,
		})
	}
	messages = append(messages, Message{
		Role:    "user",
		Content: req.Prompt,
	})

	reqBody := ChatRequest{
		Model:    req.Model,
		Messages: messages,
		Stream:   true,
	}

	jsonBody, _ := json.Marshal(reqBody)
	resp, err := http.Post(
		fmt.Sprintf("%s/api/chat", s.ollamaURL),
		"application/json",
		bytes.NewBuffer(jsonBody),
	)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	defer resp.Body.Close()

	c.Header("Content-Type", "text/event-stream")
	c.Header("Cache-Control", "no-cache")
	c.Header("Connection", "keep-alive")

	decoder := json.NewDecoder(resp.Body)
	for {
		var chatResp ChatResponse
		if err := decoder.Decode(&chatResp); err != nil {
			if err == io.EOF {
				break
			}
			break
		}
		data := fmt.Sprintf("data: %s\n\n", chatResp.Message.Content)
		c.Writer.WriteString(data)
		c.Writer.Flush()
	}
}

func (s *Server) saveConversation(c *gin.Context) {
	var req struct {
		Model    string `json:"model"`
		Prompt   string `json:"prompt"`
		Response string `json:"response"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	conversationID := uuid.New().String()
	entry := ConversationEntry{
		ID:        conversationID,
		Timestamp: time.Now(),
		Prompt:    req.Prompt,
		Response:  req.Response,
		Model:     req.Model,
	}

	conversations[conversationID] = append(conversations[conversationID], entry)

	c.JSON(200, gin.H{
		"id":    conversationID,
		"saved": true,
	})
}

func (s *Server) getHistory(c *gin.Context) {
	conversationID := c.Param("id")

	if history, exists := conversations[conversationID]; exists {
		c.JSON(200, gin.H{"history": history})
	} else {
		c.JSON(404, gin.H{"error": "Conversation not found"})
	}
}

func (s *Server) listModels(c *gin.Context) {
	resp, err := http.Get(fmt.Sprintf("%s/api/tags", s.ollamaURL))
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	defer resp.Body.Close()

	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)
	c.JSON(200, result)
}

func (s *Server) analyzeFile(c *gin.Context) {
	var req struct {
		Model string `json:"model"`
		Path  string `json:"path"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	content, err := os.ReadFile(req.Path)
	if err != nil {
		c.JSON(500, gin.H{"error": "File not found"})
		return
	}

	prompt := fmt.Sprintf(`Analyze and optimize this code:

Provide:
1. Issues or improvements
2. Optimized version
3. Explanation`, string(content))

	messages := []Message{
		{
			Role:    "system",
			Content: "You are CodeLlama-Coder, a professional AI coding assistant.",
		},
		{
			Role:    "user",
			Content: prompt,
		},
	}

	response, err := s.streamToOllama(req.Model, messages)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, gin.H{
		"response": response,
		"file":     filepath.Base(req.Path),
	})
}

func main() {
	ollamaURL := os.Getenv("OLLAMA_URL")
	if ollamaURL == "" {
		ollamaURL = "http://localhost:11434"
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	server := &Server{
		ollamaURL: ollamaURL,
	}

	gin.SetMode(gin.ReleaseMode)
	router := gin.Default()

	// CORS
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Routes
	router.POST("/api/chat", server.chat)
	router.POST("/api/chat/stream", server.chatStream)
	router.POST("/api/save", server.saveConversation)
	router.GET("/api/history/:id", server.getHistory)
	router.GET("/api/models", server.listModels)
	router.POST("/api/analyze", server.analyzeFile)

	fmt.Printf("🚀 Server running on http://localhost:%s\n", port)
	router.Run(":" + port)
}