import { useEffect, useState, useCallback, useRef } from 'react'
import { createWebSocketConnection } from '../services/api'

export const useWebSocket = (roomId, token) => {
  const [messages, setMessages] = useState([])
  const [isConnected, setIsConnected] = useState(false)
  const [error, setError] = useState(null)
  const wsRef = useRef(null)

  useEffect(() => {
    if (!roomId || !token) return

    const ws = createWebSocketConnection(roomId, token)

    ws.onopen = () => {
      console.log('WebSocket connected')
      setIsConnected(true)
      setError(null)
    }

    ws.onmessage = (event) => {
      try {
        const message = JSON.parse(event.data)
        setMessages(prev => {
          const exists = prev.find(m => m.id === message.id)
          if (exists) return prev
          return [...prev, message]
        })
      } catch (err) {
        console.error('Failed to parse message:', err)
      }
    }

    ws.onerror = (error) => {
      console.error('WebSocket error:', error)
      setError('Connection error')
      setIsConnected(false)
    }

    ws.onclose = () => {
      console.log('WebSocket disconnected')
      setIsConnected(false)
    }

    wsRef.current = ws

    return () => {
      if (wsRef.current?.readyState === WebSocket.OPEN) {
        wsRef.current.close()
      }
    }
  }, [roomId, token])

  const sendMessage = useCallback((content) => {
    if (wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(content)
    } else {
      setError('Connection not established')
    }
  }, [])

  return {
    messages,
    isConnected,
    error,
    sendMessage,
    clearMessages: () => setMessages([])
  }
}
