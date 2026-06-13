import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

const api = axios.create({
  baseURL: API_URL,
  headers: { 'Content-Type': 'application/json' }
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

export const authAPI = {
  register: (username, password) => api.post('/users', { username, password }),
  login: (username, password) => api.post('/login', { username, password }),
  getProfile: userId => api.get(`/profile/${userId}`),
  updateProfile: (userId, data) => api.put(`/profile/${userId}`, data),
  getSettings: userId => api.get(`/settings/${userId}`),
  updateSettings: (userId, data) => api.put(`/settings/${userId}`, data),
}

export const chatAPI = {
  getRooms: userId => api.get('/rooms', { params: { user_id: userId } }),
  createRoom: name => api.post('/room', { name }),
  joinRoom: (roomId, userId) => api.post('/room/join', { room_id: roomId, user_id: userId }),
  getMessages: (roomId, userId) => api.get('/message', { params: { room_id: roomId, user_id: userId } }),
  getRoomMembers: roomId => api.get(`/room/${roomId}/members`),
  sendMessage: (roomId, senderId, content) => api.post('/message', { room_id: roomId, sender_id: senderId, content }),
}

export const fileAPI = {
  uploadAvatar: (userId, file) => {
    const formData = new FormData()
    formData.append('file', file)
    return api.post(`/upload/avatar/${userId}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  }
}

export default api
