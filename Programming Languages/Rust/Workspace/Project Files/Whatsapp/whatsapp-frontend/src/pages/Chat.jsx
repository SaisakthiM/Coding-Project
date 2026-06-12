import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { roomAPI, messageAPI } from '../services/api'
import { WebSocketService } from '../services/websocket'
import { RoomList } from '../components/RoomList'
import { ChatHeader } from '../components/ChatHeader'
import { MessageList } from '../components/MessageList'
import { MessageInput } from '../components/MessageInput'
import { MembersList } from '../components/MembersList'

export const Chat = () => {
  const navigate = useNavigate()
  const { user, token, logout } = useAuth()
  
  const [rooms, setRooms] = useState([])
  const [selectedRoom, setSelectedRoom] = useState(null)
  const [messages, setMessages] = useState([])
  const [members, setMembers] = useState([])
  const [loading, setLoading] = useState(false)
  const [showMembers, setShowMembers] = useState(false)
  const [showCreateRoom, setShowCreateRoom] = useState(false)
  const [showJoinRoom, setShowJoinRoom] = useState(false)
  const [newRoomName, setNewRoomName] = useState('')
  const [joinRoomId, setJoinRoomId] = useState('')
  const [wsService, setWsService] = useState(null)
  const [error, setError] = useState('')
  const [apiUrl] = useState(import.meta.env.VITE_API_URL || 'http://localhost:8000')

  // Load user rooms
  useEffect(() => {
    if (!user) return
    loadRooms()
  }, [user])

  const loadRooms = async () => {
    try {
      const { data } = await roomAPI.getUserRooms(user.id)
      setRooms(data || [])
    } catch (err) {
      setError('Failed to load rooms')
      console.error(err)
    }
  }

  // Handle room selection
  useEffect(() => {
    if (!selectedRoom || !user) {
      if (wsService) {
        wsService.disconnect()
        setWsService(null)
      }
      setMessages([])
      return
    }

    loadRoomData()
  }, [selectedRoom, user])

  const loadRoomData = async () => {
    setLoading(true)
    try {
      // Get members
      const { data: membersData } = await roomAPI.getRoomMembers(selectedRoom.id)
      setMembers(membersData || [])

      // Connect WebSocket
      const ws = new WebSocketService(selectedRoom.id, token, apiUrl)
      
      ws.on('message', (message) => {
        setMessages(prev => {
          const exists = prev.some(m => m.id === message.id)
          return exists ? prev : [...prev, message]
        })
      })

      ws.on('error', (err) => {
        console.error('WebSocket error:', err)
        setError('Real-time connection failed')
      })

      await ws.connect()
      setWsService(ws)
    } catch (err) {
      setError('Failed to load room')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleSendMessage = (content) => {
    if (!selectedRoom || !wsService || !wsService.isConnected) {
      setError('Not connected to room')
      return
    }

    const message = JSON.stringify({
      type: 'message',
      content
    })

    wsService.send(message)
  }

  const handleCreateRoom = async () => {
    if (!newRoomName.trim()) {
      setError('Room name cannot be empty')
      return
    }

    try {
      const { data } = await roomAPI.createRoom(newRoomName)
      
      // Join the room
      await roomAPI.joinRoom(data.id, user.id)
      
      // Reload rooms
      await loadRooms()
      setNewRoomName('')
      setShowCreateRoom(false)
    } catch (err) {
      setError('Failed to create room')
      console.error(err)
    }
  }

  const handleJoinRoom = async () => {
    if (!joinRoomId.trim()) {
      setError('Room ID cannot be empty')
      return
    }

    try {
      await roomAPI.joinRoom(joinRoomId, user.id)
      await loadRooms()
      setJoinRoomId('')
      setShowJoinRoom(false)
    } catch (err) {
      setError('Failed to join room')
      console.error(err)
    }
  }

  const handleLogout = () => {
    if (wsService) {
      wsService.disconnect()
    }
    logout()
    navigate('/')
  }

  if (loading && messages.length === 0) {
    return (
      <div className="flex items-center justify-center h-screen bg-whatsapp-dark">
        <div className="text-whatsapp-textSecondary">Loading...</div>
      </div>
    )
  }

  return (
    <div className="h-screen flex bg-whatsapp-dark">
      {/* Room List */}
      <RoomList
        rooms={rooms}
        selectedRoom={selectedRoom}
        onSelectRoom={setSelectedRoom}
        onCreateRoom={() => setShowCreateRoom(true)}
      />

      {/* Chat Area */}
      <div className="flex-1 flex flex-col">
        {selectedRoom ? (
          <>
            <ChatHeader
              room={selectedRoom}
              members={members}
              onSettings={() => setShowMembers(true)}
              onLogout={handleLogout}
            />
            <MessageList
              messages={messages}
              currentUserId={user.id}
            />
            <MessageInput
              onSend={handleSendMessage}
              disabled={!wsService?.isConnected}
            />
          </>
        ) : (
          <div className="flex-1 flex items-center justify-center text-whatsapp-textSecondary">
            <div className="text-center">
              <h2 className="text-2xl font-semibold mb-2">Select a conversation</h2>
              <p className="mb-4">Choose a room to start chatting</p>
              <div className="space-x-2">
                <button
                  onClick={() => setShowCreateRoom(true)}
                  className="bg-whatsapp-primary text-black px-4 py-2 rounded-lg font-semibold hover:bg-green-500"
                >
                  Create Room
                </button>
                <button
                  onClick={() => setShowJoinRoom(true)}
                  className="bg-whatsapp-lightBg text-whatsapp-text px-4 py-2 rounded-lg font-semibold hover:bg-whatsapp-inputBg"
                >
                  Join Room
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Error Message */}
      {error && (
        <div className="fixed bottom-4 right-4 bg-red-900/30 border border-red-500 text-red-400 p-4 rounded-lg max-w-sm">
          <p>{error}</p>
          <button
            onClick={() => setError('')}
            className="text-xs mt-2 underline"
          >
            Dismiss
          </button>
        </div>
      )}

      {/* Members Modal */}
      {showMembers && (
        <MembersList
          members={members}
          onClose={() => setShowMembers(false)}
        />
      )}

      {/* Create Room Modal */}
      {showCreateRoom && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-whatsapp-lightBg rounded-lg p-6 w-96">
            <h3 className="text-xl font-semibold text-whatsapp-text mb-4">Create New Room</h3>
            <input
              type="text"
              value={newRoomName}
              onChange={(e) => setNewRoomName(e.target.value)}
              placeholder="Room name"
              className="w-full bg-whatsapp-inputBg text-whatsapp-text rounded-lg px-4 py-2 mb-4 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary"
            />
            <div className="flex gap-2">
              <button
                onClick={handleCreateRoom}
                className="flex-1 bg-whatsapp-primary text-black font-bold py-2 rounded-lg hover:bg-green-500"
              >
                Create
              </button>
              <button
                onClick={() => {
                  setShowCreateRoom(false)
                  setNewRoomName('')
                }}
                className="flex-1 bg-whatsapp-inputBg text-whatsapp-text font-bold py-2 rounded-lg hover:bg-whatsapp-border"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Join Room Modal */}
      {showJoinRoom && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-whatsapp-lightBg rounded-lg p-6 w-96">
            <h3 className="text-xl font-semibold text-whatsapp-text mb-4">Join Room</h3>
            <input
              type="text"
              value={joinRoomId}
              onChange={(e) => setJoinRoomId(e.target.value)}
              placeholder="Room ID"
              className="w-full bg-whatsapp-inputBg text-whatsapp-text rounded-lg px-4 py-2 mb-4 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary"
            />
            <div className="flex gap-2">
              <button
                onClick={handleJoinRoom}
                className="flex-1 bg-whatsapp-primary text-black font-bold py-2 rounded-lg hover:bg-green-500"
              >
                Join
              </button>
              <button
                onClick={() => {
                  setShowJoinRoom(false)
                  setJoinRoomId('')
                }}
                className="flex-1 bg-whatsapp-inputBg text-whatsapp-text font-bold py-2 rounded-lg hover:bg-whatsapp-border"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
