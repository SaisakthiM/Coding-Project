import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { chatAPI } from '../services/api'
import { WebSocketService } from '../services/websocket'
import {
  Box, AppBar, Toolbar, Typography, TextField, Button,
  List, ListItem, ListItemButton, ListItemText,
  Paper, Drawer, IconButton, Menu, MenuItem, CircularProgress,
  Dialog, DialogTitle, DialogContent, DialogActions, Chip
} from '@mui/material'
import MenuIcon from '@mui/icons-material/Menu'
import LogoutIcon from '@mui/icons-material/Logout'
import PersonIcon from '@mui/icons-material/Person'
import SendIcon from '@mui/icons-material/Send'
import AddIcon from '@mui/icons-material/Add'

export default function ChatPage() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()
  const [rooms, setRooms] = useState([])
  const [selectedRoom, setSelectedRoom] = useState(null)
  const [messages, setMessages] = useState([])
  const [newMessage, setNewMessage] = useState('')
  const [loading, setLoading] = useState(false)
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)
  const [anchorEl, setAnchorEl] = useState(null)
  const [openCreateRoom, setOpenCreateRoom] = useState(false)
  const [roomName, setRoomName] = useState('')
  const wsRef = useRef(null)
  const messagesEndRef = useRef(null)

  useEffect(() => {
    loadRooms()
  }, [user])

  const loadRooms = async () => {
    try {
      const { data } = await chatAPI.getRooms(user.id)
      setRooms(data || [])
    } catch (err) {
      console.error('Failed to load rooms:', err)
    }
  }

  const handleSendMessage = async () => {
    if (!newMessage.trim() || !selectedRoom) return

    try {
      await chatAPI.sendMessage(selectedRoom.id, user.id, newMessage)
      setNewMessage('')
    } catch (err) {
      console.error('Failed to send message:', err)
    }
  }

  const handleCreateRoom = async () => {
    if (!roomName.trim()) return
    try {
      const { data } = await chatAPI.createRoom(roomName)
      setRoomName('')
      setOpenCreateRoom(false)
      loadRooms()
    } catch (err) {
      console.error('Failed to create room:', err)
    }
  }

  const handleLogout = () => {
    logout()
    navigate('/')
  }

  return (
    <Box sx={{ display: 'flex', height: '100vh' }}>
      {/* App Bar */}
      <AppBar position="fixed" sx={{ zIndex: 1300 }}>
        <Toolbar>
          <IconButton
            color="inherit"
            edge="start"
            onClick={() => setMobileOpen(!mobileOpen)}
            sx={{ mr: 2, display: { sm: 'none' } }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>
            WhatsApp
          </Typography>
          <IconButton color="inherit" onClick={(e) => setAnchorEl(e.currentTarget)}>
            <MenuIcon />
          </IconButton>
          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={() => setAnchorEl(null)}
          >
            <MenuItem onClick={() => { navigate('/profile'); setAnchorEl(null); }}>
              <PersonIcon sx={{ mr: 1 }} /> Profile
            </MenuItem>
            <MenuItem onClick={handleLogout}>
              <LogoutIcon sx={{ mr: 1 }} /> Logout
            </MenuItem>
          </Menu>
        </Toolbar>
      </AppBar>

      {/* Sidebar */}
      <Drawer
        variant={{ xs: 'temporary', sm: 'permanent' }}
        open={mobileOpen}
        onClose={() => setMobileOpen(false)}
        sx={{
          width: 320,
          '& .MuiDrawer-paper': {
            width: 320,
            mt: 8,
            backgroundColor: '#111B21',
          },
        }}
      >
        <Box sx={{ p: 2 }}>
          <Button
            variant="contained"
            color="primary"
            fullWidth
            startIcon={<AddIcon />}
            onClick={() => setOpenCreateRoom(true)}
          >
            New Chat
          </Button>
        </Box>
        <List>
          {rooms.map((room) => (
            <ListItemButton
              key={room.id}
              selected={selectedRoom?.id === room.id}
              onClick={() => { setSelectedRoom(room); setMobileOpen(false); }}
            >
              <ListItemText
                primary={room.name}
                secondary={new Date(room.created_at).toLocaleDateString()}
              />
            </ListItemButton>
          ))}
        </List>
      </Drawer>

      {/* Chat Area */}
      <Box sx={{ flex: 1, display: 'flex', flexDirection: 'column', ml: { sm: '320px' }, mt: 8 }}>
        {selectedRoom ? (
          <>
            {/* Chat Header */}
            <Paper sx={{ p: 2, backgroundColor: '#202C33' }}>
              <Typography variant="h6">{selectedRoom.name}</Typography>
            </Paper>

            {/* Messages */}
            <Box
              sx={{
                flex: 1,
                overflowY: 'auto',
                p: 2,
                display: 'flex',
                flexDirection: 'column',
                gap: 1,
              }}
            >
              {messages.map((msg) => (
                <Box
                  key={msg.id}
                  sx={{
                    alignSelf: msg.sender_id === user.id ? 'flex-end' : 'flex-start',
                    maxWidth: '70%',
                  }}
                >
                  <Paper
                    sx={{
                      p: 1.5,
                      backgroundColor: msg.sender_id === user.id ? 'primary.main' : '#2A3F35',
                      color: msg.sender_id === user.id ? 'black' : 'text.primary',
                    }}
                  >
                    <Typography variant="body2">{msg.content}</Typography>
                    <Typography
                      variant="caption"
                      sx={{
                        display: 'block',
                        mt: 0.5,
                        opacity: 0.7,
                      }}
                    >
                      {new Date(msg.created_at).toLocaleTimeString()}
                    </Typography>
                  </Paper>
                </Box>
              ))}
              <div ref={messagesEndRef} />
            </Box>

            {/* Input */}
            <Paper sx={{ p: 2, backgroundColor: '#202C33' }}>
              <Box sx={{ display: 'flex', gap: 1 }}>
                <TextField
                  fullWidth
                  size="small"
                  placeholder="Type a message..."
                  value={newMessage}
                  onChange={(e) => setNewMessage(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                />
                <IconButton
                  color="primary"
                  onClick={handleSendMessage}
                  disabled={!newMessage.trim()}
                >
                  <SendIcon />
                </IconButton>
              </Box>
            </Paper>
          </>
        ) : (
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', flex: 1 }}>
            <Typography color="text.secondary">Select a chat to start messaging</Typography>
          </Box>
        )}
      </Box>

      {/* Create Room Dialog */}
      <Dialog open={openCreateRoom} onClose={() => setOpenCreateRoom(false)}>
        <DialogTitle>Create New Chat</DialogTitle>
        <DialogContent sx={{ minWidth: 300 }}>
          <TextField
            autoFocus
            fullWidth
            label="Chat Name"
            value={roomName}
            onChange={(e) => setRoomName(e.target.value)}
            sx={{ mt: 2 }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenCreateRoom(false)}>Cancel</Button>
          <Button onClick={handleCreateRoom} variant="contained" color="primary">
            Create
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  )
}
