import { useState } from 'react'

export const MessageInput = ({ onSend, disabled = false }) => {
  const [message, setMessage] = useState('')

  const handleSubmit = (e) => {
    e.preventDefault()
    if (message.trim() && !disabled) {
      onSend(message)
      setMessage('')
    }
  }

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSubmit(e)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="p-4 bg-whatsapp-lightBg border-t border-whatsapp-border">
      <div className="flex gap-3">
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Type a message..."
          disabled={disabled}
          className="flex-1 bg-whatsapp-inputBg text-whatsapp-text rounded-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary disabled:opacity-50"
        />
        <button
          type="submit"
          disabled={disabled || !message.trim()}
          className="bg-whatsapp-primary text-black rounded-full px-6 py-2 font-semibold hover:bg-green-500 disabled:opacity-50 disabled:cursor-not-allowed transition"
        >
          Send
        </button>
      </div>
    </form>
  )
}
