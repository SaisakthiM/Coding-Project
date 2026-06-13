import axios from 'axios'

const API_BASE_URL = 'http://localhost:8000'

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
}, error => Promise.reject(error))

// ============ AUTH APIs ============
export const authAPI = {
  register: async (username, password) => {
    const response = await apiClient.post('/users', { username, password })
    console.log('Register response:', response.data)
    return response.data
  },

  login: async (username, password) => {
    const response = await apiClient.post('/login', { username, password })
    console.log('Login response:', response.data)
    return response.data
  },

  getUser: async (userId) => {
    const response = await apiClient.get(`/users/${userId}`)
    return response.data
  },

  updateUser: async (userId, newName) => {
    const response = await apiClient.put(`/users/${userId}`, { new_name: newName })
    return response.data
  },

  deleteUser: async (userId) => {
    const response = await apiClient.delete(`/users/${userId}`)
    return response.data
  }
}

// ============ ROOM APIs ============
export const roomAPI = {
  createRoom: async (name) => {
    const response = await apiClient.post('/room', { name })
    console.log('Create room response:', response.data)
    return response.data
  },

  getUserRooms: async (userId) => {
    try {
      const response = await apiClient.get('/rooms', {
        params: { user_id: userId }
      })
      console.log('Get rooms response:', response.data)
      return response.data || []
    } catch (error) {
      console.error('Error fetching rooms:', error.response?.data || error.message)
      return []
    }
  },

  joinRoom: async (roomId, userId) => {
    const response = await apiClient.post('/room/join', {
      room_id: roomId,
      user_id: userId
    })
    console.log('Join room response:', response.data)
    return response.data
  },

  getRoomMembers: async (roomId) => {
    const response = await apiClient.get(`/room/${roomId}/members`)
    console.log('Get members response:', response.data)
    return response.data || []
  }
}

// ============ MESSAGE APIs ============
export const messageAPI = {
  createMessage: async (roomId, senderId, content) => {
    const response = await apiClient.post('/message', {
      room_id: roomId,
      sender_id: senderId,
      content
    })
    return response.data
  },

  getMessages: async (roomId, userId) => {
    const response = await apiClient.get('/message', {
      params: { room_id: roomId, user_id: userId }
    })
    return response.data || []
  }
}

// ============ WebSocket ============
export const createWebSocketConnection = (roomId, token) => {
  const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  const wsUrl = `${wsProtocol}//${window.location.hostname}:8000/ws/${roomId}?token=${token}`
  return new WebSocket(wsUrl)
}

export default apiClient