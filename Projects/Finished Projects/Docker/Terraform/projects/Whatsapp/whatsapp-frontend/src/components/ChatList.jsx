/* eslint-disable react/react-in-jsx-scope */
import { useEffect, useState } from 'react'
import { useAuthStore } from '../store/authStore'
import { roomAPI } from '../services/api'
import { formatDistanceToNow } from 'date-fns'
import "react"

export default function ChatList({ selectedRoomId, onRoomSelect, onLogout }) {
  const { user, logout } = useAuthStore()
  const [rooms, setRooms] = useState([])
  const [isLoading, setIsLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [showCreateDialog, setShowCreateDialog] = useState(false)
  const [newRoomName, setNewRoomName] = useState('')

  useEffect(() => {
    const loadRooms = async () => {
      if (user?.id) {
        try {
          console.log('Loading rooms for user:', user.id)
          const data = await roomAPI.getUserRooms(user.id)
          console.log('Loaded rooms:', data)
          setRooms(Array.isArray(data) ? data : [])
        } catch (error) {
          console.error('Failed to load rooms:', error)
          setRooms([])
        } finally {
          setIsLoading(false)
        }
      }
    }

    loadRooms()
    const interval = setInterval(loadRooms, 5000)
    return () => clearInterval(interval)
  }, [user?.id])

  const handleCreateRoom = async (e) => {
    e.preventDefault()
    if (!newRoomName.trim()) return

    try {
      console.log('Creating room:', newRoomName)
      const response = await roomAPI.createRoom(newRoomName)
      console.log('Room created:', response)
      
      // Join the room automatically
      if (response && response.id) {
        await roomAPI.joinRoom(response.id, user.id)
      }
      
      setNewRoomName('')
      setShowCreateDialog(false)
      
      // Reload rooms
      const data = await roomAPI.getUserRooms(user.id)
      setRooms(Array.isArray(data) ? data : [])
    } catch (error) {
      console.error('Failed to create room:', error)
    }
  }

  const handleLogout = () => {
    logout()
    onLogout()
  }

  const filteredRooms = rooms.filter(room =>
    room.name.toLowerCase().includes(searchTerm.toLowerCase())
  )

  return (
    <div className="h-screen w-80 bg-white border-r border-whatsapp-border flex flex-col">
      {/* Header */}
      <div className="bg-whatsapp-green p-4 text-white">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-2xl font-bold">WhatsApp</h1>
            <p className="text-xs text-green-100">{user?.username}</p>
          </div>
          <button
            onClick={handleLogout}
            className="hover:bg-green-600 p-2 rounded-full transition-colors"
            title="Logout"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </button>
        </div>

        {/* Search Bar */}
        <div className="relative">
          <svg className="absolute left-3 top-3 w-5 h-5 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <input
            type="text"
            placeholder="Search chats..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-green-100 text-whatsapp-dark placeholder-green-600 rounded-full text-sm focus:outline-none focus:ring-2 focus:ring-white"
          />
        </div>
      </div>

      {/* Create Room Button */}
      <div className="p-3 border-b border-whatsapp-border">
        {!showCreateDialog ? (
          <button
            onClick={() => setShowCreateDialog(true)}
            className="w-full flex items-center justify-center gap-2 bg-whatsapp-green hover:bg-green-500 text-white font-semibold py-2 rounded-lg transition-colors"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
            </svg>
            New Chat
          </button>
        ) : (
          <form onSubmit={handleCreateRoom} className="space-y-2">
            <input
              autoFocus
              type="text"
              placeholder="Room name..."
              value={newRoomName}
              onChange={(e) => setNewRoomName(e.target.value)}
              className="input-field text-sm"
            />
            <div className="flex gap-2">
              <button
                type="submit"
                className="flex-1 text-sm py-1 bg-whatsapp-green text-white rounded hover:bg-green-500 transition-colors"
              >
                Create
              </button>
              <button
                type="button"
                onClick={() => setShowCreateDialog(false)}
                className="flex-1 text-sm py-1 bg-whatsapp-light text-whatsapp-dark rounded hover:bg-whatsapp-border transition-colors"
              >
                Cancel
              </button>
            </div>
          </form>
        )}
      </div>

      {/* Chat List */}
      <div className="flex-1 overflow-y-auto">
        {isLoading ? (
          <div className="p-4 text-center text-whatsapp-gray text-sm">
            Loading chats...
          </div>
        ) : filteredRooms.length === 0 ? (
          <div className="p-4 text-center text-whatsapp-gray text-sm">
            {searchTerm ? 'No chats found' : 'No chats yet. Create one!'}
          </div>
        ) : (
          filteredRooms.map(room => (
            <div
              key={room.id}
              onClick={() => onRoomSelect(room.id)}
              className={`p-4 cursor-pointer border-b border-whatsapp-border hover:bg-whatsapp-light transition-colors ${
                selectedRoomId === room.id ? 'bg-whatsapp-light' : ''
              }`}
            >
              <h3 className="font-semibold text-whatsapp-dark truncate">{room.name}</h3>
              <p className="text-xs text-whatsapp-gray mt-1">
                {formatDistanceToNow(new Date(room.created_at), { addSuffix: true })}
              </p>
            </div>
          ))
        )}
      </div>
    </div>
  )
}
