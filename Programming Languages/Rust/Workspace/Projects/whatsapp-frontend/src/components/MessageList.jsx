import { useEffect, useRef } from 'react'
import { MessageBubble } from './MessageBubble'

export const MessageList = ({ messages, currentUserId, members = [] }) => {
  const messagesEndRef = useRef(null)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  const getMemberName = (userId) => {
    const member = members.find(m => m.user_id === userId)
    return member?.username || 'Unknown'
  }

  return (
    <div className="flex-1 overflow-y-auto bg-gradient-to-b from-whatsapp-dark to-whatsapp-darkBg p-4 space-y-2">
      {messages.length === 0 ? (
        <div className="flex items-center justify-center h-full">
          <div className="text-center text-whatsapp-textSecondary">
            <div className="text-5xl mb-3">💬</div>
            <p className="font-semibold">No messages yet</p>
            <p className="text-sm mt-1">Start a conversation</p>
          </div>
        </div>
      ) : (
        <>
          {messages.map((msg) => (
            <MessageBubble
              key={msg.id}
              message={msg}
              isOwn={msg.sender_id === currentUserId}
              senderName={getMemberName(msg.sender_id)}
            />
          ))}
          <div ref={messagesEndRef} className="h-1" />
        </>
      )}
    </div>
  )
}
