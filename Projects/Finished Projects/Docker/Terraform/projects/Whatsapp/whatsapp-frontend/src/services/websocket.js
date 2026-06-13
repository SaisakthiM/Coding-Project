export class WebSocketService {
  constructor(roomId, token, baseUrl = 'http://localhost:8000') {
    this.roomId = roomId
    this.token = token
    this.baseUrl = baseUrl.replace('http', 'ws')
    this.ws = null
    this.listeners = new Map()
    this.messageQueue = []
    this.isConnected = false
  }

  connect() {
    return new Promise((resolve, reject) => {
      try {
        const wsUrl = `${this.baseUrl}/ws/${this.roomId}?token=${encodeURIComponent(this.token)}`
        this.ws = new WebSocket(wsUrl)

        this.ws.onopen = () => {
          console.log('WebSocket connected')
          this.isConnected = true
          while (this.messageQueue.length > 0) {
            const msg = this.messageQueue.shift()
            this.ws.send(msg)
          }
          resolve()
        }

        this.ws.onmessage = (event) => {
          try {
            const message = JSON.parse(event.data)
            this.emit('message', message)
          } catch (err) {
            console.error('Failed to parse message:', err)
          }
        }

        this.ws.onerror = (error) => {
          console.error('WebSocket error:', error)
          this.isConnected = false
          this.emit('error', error)
          reject(error)
        }

        this.ws.onclose = () => {
          console.log('WebSocket disconnected')
          this.isConnected = false
          this.emit('disconnect')
        }
      } catch (err) {
        reject(err)
      }
    })
  }

  send(message) {
    if (this.isConnected && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(message)
    } else {
      this.messageQueue.push(message)
    }
  }

  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, [])
    }
    this.listeners.get(event).push(callback)
  }

  emit(event, data) {
    if (this.listeners.has(event)) {
      this.listeners.get(event).forEach(callback => callback(data))
    }
  }

  disconnect() {
    if (this.ws) {
      this.ws.close()
      this.ws = null
      this.isConnected = false
    }
  }
}
