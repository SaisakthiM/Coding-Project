# Modern MUI React Frontend - Complete Implementation Guide

## Project Structure

```
whatsapp-mui-frontend/
├── src/
│   ├── components/
│   │   ├── ChatList.jsx
│   │   ├── ChatWindow.jsx
│   │   ├── MessageInput.jsx
│   │   ├── ProfileDialog.jsx
│   │   ├── SettingsDialog.jsx
│   │   └── AvatarUpload.jsx
│   ├── pages/
│   │   ├── LoginPage.jsx
│   │   ├── ChatPage.jsx
│   │   └── ProfilePage.jsx
│   ├── context/
│   │   └── AuthContext.jsx
│   ├── services/
│   │   └── api.js
│   ├── hooks/
│   │   └── useAuth.js
│   ├── App.jsx
│   └── main.jsx
├── index.html
├── vite.config.js
├── package.json
├── .env.example
└── README.md
```

## Key Features

✨ **Modern Material-UI Design**  
🔐 **JWT Authentication**  
👤 **User Profile & Settings**  
📤 **File Upload with MinIO**  
💬 **Real-time Chat**  
🎨 **Dark/Light Theme Support**  
📱 **Responsive Design**

## Installation & Setup

```bash
npm install
npm run dev
```

## API Integration

### Authentication
```javascript
POST /login                    - Login user
POST /users                    - Register user
GET  /profile/{user_id}       - Get profile
PUT  /profile/{user_id}       - Update profile
GET  /settings/{user_id}      - Get settings
PUT  /settings/{user_id}      - Update settings
POST /upload/avatar/{user_id} - Upload avatar
```

### Chat
```javascript
GET  /rooms?user_id=          - Get user rooms
POST /room                    - Create room
POST /room/join               - Join room
POST /message                 - Send message
GET  /message                 - Get messages
WS   /ws/{room_id}           - WebSocket
```

## File Structure Details

### 1. AuthContext.jsx
Manages user authentication state globally

### 2. api.js
Handles all API calls with Axios interceptors for JWT token

### 3. LoginPage.jsx
Modern login/register form using MUI components

### 4. ChatPage.jsx
Main chat interface with sidebar and messages

### 5. ProfilePage.jsx
User profile with avatar upload and settings

### 6. Component Usage
All components use MUI Box, Card, TextField, Button, etc.

## MUI Components Used

- **Box** - Layout
- **Card** - Message bubbles
- **TextField** - Input fields
- **Button** - Actions
- **Avatar** - User avatars
- **Dialog** - Modals
- **List** - Chat list
- **AppBar** - Headers
- **Drawer** - Sidebar
- **CircularProgress** - Loading
- **Icons** - From @mui/icons-material

## Styling

All styling uses MUI's sx prop for responsive design:

```jsx
<Box sx={{
  display: 'flex',
  flexDirection: { xs: 'column', md: 'row' },
  gap: 2,
  p: 2,
}}>
  Content
</Box>
```

## Colors (WhatsApp Theme)

```
Primary: #25D366 (WhatsApp Green)
Secondary: #075E54 (Dark Green)
Background: #0A0E11 (Very Dark)
Paper: #111B21 (Dark)
Text: #E9EDEF (Light Gray)
```

## Key Configuration

### .env.example
```
VITE_API_URL=http://localhost:8000
```

### MUI Theme
Configured in main.jsx with dark mode by default

## Authentication Flow

1. User visits login page
2. Register or login with username/password
3. Backend returns JWT token
4. Token stored in localStorage
5. Token added to all API requests via Axios interceptor
6. User navigated to chat page
7. Profile/settings accessible from top menu

## File Upload Flow

1. User clicks "Change Avatar" in profile
2. Frontend sends presigned URL request to backend
3. Backend returns S3/MinIO presigned URL
4. Frontend uploads directly to S3/MinIO
5. Frontend updates user avatar in database

## WebSocket Connection

1. User selects or creates chat room
2. WebSocket connects to /ws/{room_id}
3. Messages received in real-time
4. Disconnect on room change or logout

## Settings Features

- Theme (Dark/Light)
- Language (EN/ES/FR, etc.)
- Notification Preferences
- Account Settings

## Responsive Design

- Mobile-first approach
- Breakpoints: xs, sm, md, lg, xl
- Drawer navigation on mobile
- Full sidebar on desktop

## Error Handling

- API errors displayed in Snackbar
- User-friendly error messages
- Network error recovery
- Validation on inputs

## Performance Optimizations

- Code splitting with React Router
- Lazy loading images
- Memoization with React.memo
- Efficient re-renders

## Deployment

```bash
npm run build
# Deploy dist/ folder
```

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Development Commands

```bash
npm run dev       # Start dev server
npm run build     # Production build
npm run preview   # Preview production build
```

## Troubleshooting

### CORS Errors
- Make sure backend has CORS enabled
- Check API_URL in .env

### Token Issues
- Clear localStorage and re-login
- Check token expiration

### WebSocket Fails
- Verify room ID is UUID
- Check backend WebSocket is running
- Verify token is valid

### File Upload Issues
- Check MinIO is running
- Verify S3 credentials in backend .env
- Check bucket exists

## Next Steps

1. Customize colors/theme
2. Add more rooms/chat features
3. Implement typing indicators
4. Add file sharing
5. Add voice/video calls
6. Deploy to production

---

## Create Files

You'll need to create each file based on the component structure. Here's a template:

### src/App.jsx
```jsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import { useAuth } from './hooks/useAuth'
import LoginPage from './pages/LoginPage'
import ChatPage from './pages/ChatPage'
import ProfilePage from './pages/ProfilePage'

function ProtectedRoute({ children }) {
  const { isAuthenticated, loading } = useAuth()
  if (loading) return <div>Loading...</div>
  return isAuthenticated ? children : <Navigate to="/" />
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<LoginPage />} />
          <Route path="/chat" element={<ProtectedRoute><ChatPage /></ProtectedRoute>} />
          <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}
```

### src/hooks/useAuth.js
```jsx
import { useContext } from 'react'
import { AuthContext } from '../context/AuthContext'

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) throw new Error('useAuth must be within AuthProvider')
  return context
}
```

### src/services/api.js
```javascript
import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8000'
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

export const authAPI = {
  register: (username, password) => api.post('/users', { username, password }),
  login: (username, password) => api.post('/login', { username, password }),
  getProfile: (userId) => api.get(`/profile/${userId}`),
  updateProfile: (userId, data) => api.put(`/profile/${userId}`, data),
  getSettings: (userId) => api.get(`/settings/${userId}`),
  updateSettings: (userId, data) => api.put(`/settings/${userId}`, data),
}

export const chatAPI = {
  getRooms: (userId) => api.get('/rooms', { params: { user_id: userId } }),
  createRoom: (name) => api.post('/room', { name }),
  joinRoom: (roomId, userId) => api.post('/room/join', { room_id: roomId, user_id: userId }),
  getMessages: (roomId, userId) => api.get('/message', { params: { room_id: roomId, user_id: userId } }),
  sendMessage: (roomId, senderId, content) => api.post('/message', { room_id: roomId, sender_id: senderId, content }),
}

export const fileAPI = {
  getPresignedUrl: (filename, contentType) => api.post('/upload/presigned', { filename, content_type: contentType }),
  uploadAvatar: (userId, file) => {
    const formData = new FormData()
    formData.append('file', file)
    return api.post(`/upload/avatar/${userId}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  }
}

export default api
```

This provides the complete architecture. You can now implement each component file using these templates!
