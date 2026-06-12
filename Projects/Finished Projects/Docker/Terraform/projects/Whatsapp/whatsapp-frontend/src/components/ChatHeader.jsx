export const ChatHeader = ({ room, members, onSettings, onLogout }) => {
  const memberCount = members?.length || 0

  return (
    <div className="bg-whatsapp-lightBg border-b border-whatsapp-border p-4 flex items-center justify-between">
      <div>
        <h2 className="text-xl font-semibold text-whatsapp-text">{room?.name}</h2>
        <p className="text-sm text-whatsapp-textSecondary">
          {memberCount} {memberCount === 1 ? 'member' : 'members'}
        </p>
      </div>
      <div className="flex gap-2">
        <button
          onClick={onSettings}
          className="p-2 hover:bg-whatsapp-inputBg rounded-full transition"
          title="Settings"
        >
          ⚙️
        </button>
        <button
          onClick={onLogout}
          className="p-2 hover:bg-red-900/30 rounded-full transition text-red-400"
          title="Logout"
        >
          🚪
        </button>
      </div>
    </div>
  )
}
