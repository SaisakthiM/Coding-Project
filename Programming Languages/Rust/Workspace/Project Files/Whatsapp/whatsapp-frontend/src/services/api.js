import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Add token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Auth APIs
export const authAPI = {
  register: (username, password) => 
    api.post('/users', { username, password }),
  
  login: (username, password) => 
    api.post('/login', { username, password }),
  
  getUser: (userId) => 
    api.get(`/users/${userId}`),
  
  updateUsername: (userId, newName) => 
    api.put(`/users/${userId}`, { new_name: newName }),
  
  deleteUser: (userId) => 
    api.delete(`/users/${userId}`)
}

// Room APIs
export const roomAPI = {
  createRoom: (name) => 
    api.post('/room', { name }),
  
  joinRoom: (roomId, userId) => 
    api.post('/room/join', { room_id: roomId, user_id: userId }),
  
  getUserRooms: (userId) => 
    api.get('/rooms', { params: { user_id: userId } }),
  
  getRoomMembers: (roomId) => 
    api.get(`/room/${roomId}/members`)
}

// Message APIs
export const messageAPI = {
  sendMessage: (roomId, senderId, content) => 
    api.post('/message', {
      room_id: roomId,
      sender_id: senderId,
      content
    }),
  
  getMessages: (roomId, userId) => 
    api.get('/message', { params: { room_id: roomId, user_id: userId } })
}

export default api
