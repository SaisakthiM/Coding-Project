package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/redis/go-redis/v9"
	"context"
)

func main() {
	fmt.Println("Starting Go microservice...")

	redisHost := os.Getenv("REDIS_HOST")
	if redisHost == "" {
		redisHost = "redis"
	}
	redisPort := os.Getenv("REDIS_PORT")
	if redisPort == "" {
		redisPort = "6379"
	}

	// Connect to Redis
	rdb := redis.NewClient(&redis.Options{
		Addr: fmt.Sprintf("%s:%s", redisHost, redisPort),
	})
	ctx := context.Background()

	_, err := rdb.Ping(ctx).Result()
	if err != nil {
		log.Fatalf("Cannot connect to Redis: %v", err)
	}
	fmt.Println("Connected to Redis!")

	// Simple HTTP server
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello from Go microservice!"))
	})

	fmt.Println("Listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
	
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
})

}

