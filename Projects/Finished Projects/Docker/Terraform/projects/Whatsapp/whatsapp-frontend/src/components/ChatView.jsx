import { useEffect, useRef, useState } from 'react'
import { useAuthStore } from '../store/authStore'
import { useWebSocket } from '../hooks/useWebSocket'
import { roomAPI } from '../services/api'
import { formatDistanceToNow } from 'date-fns'

export default function ChatView({ roomId, roomName }) {
  const { user, token } = useAuthStore()
  const { messages, isConnected, sendMessage } = useWebSocket(roomId, token)
  const [messageText, setMessageText] = useState('')
  const [members, setMembers] = useState([])
  const [showMembers, setShowMembers] = useState(false)
  const [showMenu, setShowMenu] = useState(false)
  const messagesEndRef = useRef(null)

  useEffect(() => {
    const loadMembers = async () => {
      try {
        const data = await roomAPI.getRoomMembers(roomId)
        setMembers(data || [])
      } catch (error) {
        console.error('Failed to load members:', error)
      }
    }

    if (roomId) {
      loadMembers()
    }
  }, [roomId])

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages])

  const handleSendMessage = (e) => {
    e.preventDefault()
    if (messageText.trim() && isConnected) {
      sendMessage(messageText)
      setMessageText('')
    }
  }

  const isCurrentUserMessage = (senderId) => senderId === user?.id

  return (
    <div className="flex-1 flex flex-col bg-whatsapp-lighter h-screen">
      {/* Header with Profile */}
      <div className="bg-whatsapp-green text-white px-6 py-4 shadow-sm">
        <div className="flex items-center justify-between">
          <div className="flex-1">
            <h2 className="text-xl font-semibold">{roomName}</h2>
            <div className="flex items-center gap-2 mt-1">
              <span className={`inline-block w-2 h-2 rounded-full ${isConnected ? 'bg-green-300' : 'bg-yellow-300'}`}></span>
              <p className="text-sm text-green-100">
                {isConnected ? 'Online' : 'Connecting...'}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setShowMembers(!showMembers)}
              className="hover:bg-green-600 p-2 rounded-full transition-colors"
              title="Members"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 12H9m6 0a6 6 0 11-12 0 6 6 0 0112 0z" />
              </svg>
            </button>

            <div className="relative">
              <button
                onClick={() => setShowMenu(!showMenu)}
                className="hover:bg-green-600 p-2 rounded-full transition-colors"
              >
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" />
                </svg>
              </button>
              {showMenu && (
                <div className="absolute right-0 mt-2 w-48 bg-white text-whatsapp-dark rounded-lg shadow-lg z-10">
                  <button className="w-full text-left px-4 py-2 hover:bg-whatsapp-light">Search Messages</button>
                  <button className="w-full text-left px-4 py-2 hover:bg-whatsapp-light">Media</button>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex overflow-hidden">
        {/* Messages Area */}
        <div className="flex-1 flex flex-col chat-bg">
          {/* Messages */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3 flex flex-col">
            {messages.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-full text-whatsapp-gray">
                <svg className="w-16 h-16 mb-3 opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <p className="text-sm">No messages yet</p>
                <p className="text-xs text-whatsapp-gray/70">Start the conversation!</p>
              </div>
            ) : (
              messages.map(msg => (
                <div
                  key={msg.id}
                  className={`flex ${isCurrentUserMessage(msg.sender_id) ? 'justify-end' : 'justify-start'}`}
                >
                  <div
                    className={`message-bubble animate-slide-in ${
                      isCurrentUserMessage(msg.sender_id) ? 'message-sent' : 'message-received'
                    }`}
                  >
                    <p className="break-words">{msg.content}</p>
                    <p className={`text-xs mt-1 ${isCurrentUserMessage(msg.sender_id) ? 'text-green-100' : 'text-whatsapp-gray'}`}>
                      {formatDistanceToNow(new Date(msg.created_at), { addSuffix: false })}
                    </p>
                  </div>
                </div>
              ))
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Message Input */}
          <form onSubmit={handleSendMessage} className="p-4 flex gap-3">
            <input
              type="text"
              value={messageText}
              onChange={(e) => setMessageText(e.target.value)}
              placeholder="Type a message..."
              disabled={!isConnected}
              className="flex-1 px-4 py-3 rounded-full border border-whatsapp-border focus:border-whatsapp-green focus:ring-1 focus:ring-whatsapp-green disabled:opacity-50 disabled:cursor-not-allowed"
            />
            <button
              type="submit"
              disabled={!isConnected || !messageText.trim()}
              className="bg-whatsapp-green hover:bg-green-500 disabled:opacity-50 disabled:cursor-not-allowed text-white p-3 rounded-full transition-colors"
            >
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M16.6915026,12.4744748 L3.50612381,13.2599618 C3.19218622,13.2599618 3.03521743,13.4170592 3.03521743,13.5741566 L1.15159189,20.0151496 C0.8376543,20.8006365 0.99,21.89 1.77946707,22.52 C2.40,22.99 3.50612381,23.1 4.13399899,22.99 L21.714504,14.0454487 C22.6563168,13.5741566 23.1272231,12.6315722 22.9702544,11.6889879 L4.13399899,1.01345964 C3.34915502,0.9 2.40734225,1.00636533 1.77946707,1.4776575 C0.994623095,2.10604706 0.837654326,3.0486314 1.15159189,3.98701575 L3.03521743,10.4280088 C3.03521743,10.5851061 3.19218622,10.7422035 3.50612381,10.7422035 L16.6915026,11.5276905 C16.6915026,11.5276905 17.1624089,11.5276905 17.1624089,12.0989827 C17.1624089,12.6315722 16.6915026,12.4744748 16.6915026,12.4744748 Z" />
              </svg>
            </button>
          </form>
        </div>

        {/* Members Sidebar */}
        {showMembers && (
          <div className="w-72 border-l border-whatsapp-border bg-whatsapp-lighter flex flex-col">
            <div className="p-4 border-b border-whatsapp-border">
              <h3 className="font-semibold text-whatsapp-dark mb-1">Members</h3>
              <p className="text-xs text-whatsapp-gray">{members.length} members</p>
            </div>
            <div className="flex-1 overflow-y-auto">
              {members.map(member => (
                <div
                  key={member.user_id}
                  className="p-4 border-b border-whatsapp-border hover:bg-whatsapp-light transition-colors"
                >
                  <p className="font-medium text-whatsapp-dark text-sm">{member.username}</p>
                  <p className="text-xs text-whatsapp-gray mt-1">
                    Last seen {formatDistanceToNow(new Date(member.last_seen_at), { addSuffix: true })}
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
