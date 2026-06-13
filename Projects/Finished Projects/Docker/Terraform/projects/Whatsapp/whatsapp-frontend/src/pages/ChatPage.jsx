import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuthStore } from '../store/authStore'
import { roomAPI } from '../services/api'
import ChatList from '../components/ChatList'
import ChatView from '../components/ChatView'

export default function ChatPage() {
  const navigate = useNavigate()
  const { user, token } = useAuthStore()
  const [selectedRoomId, setSelectedRoomId] = useState(null)
  const [selectedRoomName, setSelectedRoomName] = useState('')
  const [rooms, setRooms] = useState([])

  useEffect(() => {
    if (!user || !token) {
      navigate('/login')
    }
  }, [user, token, navigate])

  useEffect(() => {
    const loadRooms = async () => {
      if (user?.id) {
        try {
          const data = await roomAPI.getUserRooms(user.id)
          setRooms(data || [])
          if (data && data.length > 0 && !selectedRoomId) {
            setSelectedRoomId(data[0].id)
            setSelectedRoomName(data[0].name)
          }
        } catch (error) {
          console.error('Failed to load rooms:', error)
        }
      }
    }

    loadRooms()
  }, [user?.id])

  const handleRoomSelect = (roomId) => {
    setSelectedRoomId(roomId)
    const room = rooms.find(r => r.id === roomId)
    if (room) {
      setSelectedRoomName(room.name)
    }
  }

  const handleLogout = () => {
    navigate('/login')
  }

  return (
    <div className="flex h-screen bg-white overflow-hidden">
      {/* Sidebar */}
      <ChatList
        selectedRoomId={selectedRoomId}
        onRoomSelect={handleRoomSelect}
        onLogout={handleLogout}
      />

      {/* Chat Area */}
      {selectedRoomId ? (
        <ChatView roomId={selectedRoomId} roomName={selectedRoomName} />
      ) : (
        <div className="flex-1 flex items-center justify-center bg-whatsapp-light">
          <div className="text-center">
            <svg className="w-20 h-20 mx-auto mb-4 opacity-30 text-whatsapp-gray" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
            </svg>
            <p className="text-lg font-semibold text-whatsapp-gray">Select a chat to start messaging</p>
            <p className="text-sm text-whatsapp-gray/70 mt-2">Or create a new one from the menu</p>
          </div>
        </div>
      )}
    </div>
  )
}
