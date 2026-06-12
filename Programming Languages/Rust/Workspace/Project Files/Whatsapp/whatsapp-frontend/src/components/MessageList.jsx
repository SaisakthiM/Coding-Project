import { useEffect, useRef } from 'react'

export const MessageList = ({ messages, currentUserId }) => {
  const messagesEndRef = useRef(null)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  const formatTime = (timestamp) => {
    return new Date(timestamp).toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  return (
    <div className="flex-1 overflow-y-auto bg-whatsapp-dark p-4 space-y-4">
      {messages.length === 0 ? (
        <div className="flex items-center justify-center h-full">
          <div className="text-center text-whatsapp-textSecondary">
            <p>No messages yet</p>
            <p className="text-sm">Start a conversation</p>
          </div>
        </div>
      ) : (
        <>
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex ${
                msg.sender_id === currentUserId ? 'justify-end' : 'justify-start'
              }`}
            >
              <div
                className={`max-w-xs px-4 py-2 rounded-lg ${
                  msg.sender_id === currentUserId
                    ? 'bg-whatsapp-primary text-black'
                    : 'bg-whatsapp-inputBg text-whatsapp-text'
                }`}
              >
                <p className="break-words">{msg.content}</p>
                <p
                  className={`text-xs mt-1 ${
                    msg.sender_id === currentUserId
                      ? 'text-black/70'
                      : 'text-whatsapp-textSecondary'
                  }`}
                >
                  {formatTime(msg.created_at)}
                </p>
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </>
      )}
    </div>
  )
}
