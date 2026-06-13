import { useEffect } from 'react'

export const MembersList = ({ members, onClose, onJoinRoom }) => {
  const isOnline = (lastSeenAt) => {
    if (!lastSeenAt) return false
    const lastSeen = new Date(lastSeenAt).getTime()
    const now = new Date().getTime()
    const fiveMinutesAgo = now - 5 * 60 * 1000
    return lastSeen > fiveMinutesAgo
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-whatsapp-lightBg rounded-lg p-6 w-96 max-h-96 overflow-y-auto">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-xl font-semibold text-whatsapp-text">Members</h3>
          <button
            onClick={onClose}
            className="text-whatsapp-textSecondary hover:text-whatsapp-text"
          >
            ✕
          </button>
        </div>

        <div className="space-y-2">
          {members.map((member) => (
            <div
              key={member.user_id}
              className="p-3 bg-whatsapp-inputBg rounded-lg flex items-center justify-between"
            >
              <div className="flex-1">
                <p className="font-semibold text-whatsapp-text">{member.username}</p>
                <p className="text-xs text-whatsapp-textSecondary">
                  {isOnline(member.last_seen_at) ? '🟢 Online' : '⚫ Offline'}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
