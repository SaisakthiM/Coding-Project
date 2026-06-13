export const MessageBubble = ({ message, isOwn, senderName }) => {
  const formatTime = (timestamp) => {
    return new Date(timestamp).toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    })
  }

  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'} mb-3 animate-fadeIn`}>
      <div
        className={`max-w-xs lg:max-w-md px-4 py-2.5 rounded-2xl ${
          isOwn
            ? 'bg-gradient-to-r from-whatsapp-primary to-green-500 text-black rounded-br-none'
            : 'bg-whatsapp-inputBg text-whatsapp-text rounded-bl-none'
        } shadow-md hover:shadow-lg transition-shadow`}
      >
        {!isOwn && (
          <p className="text-xs font-semibold text-whatsapp-primary mb-1">
            {senderName}
          </p>
        )}
        <p className="break-words text-sm leading-relaxed">{message.content}</p>
        <p
          className={`text-xs mt-1.5 ${
            isOwn
              ? 'text-black/60'
              : 'text-whatsapp-textSecondary'
          }`}
        >
          {formatTime(message.created_at)}
        </p>
      </div>
    </div>
  )
}
