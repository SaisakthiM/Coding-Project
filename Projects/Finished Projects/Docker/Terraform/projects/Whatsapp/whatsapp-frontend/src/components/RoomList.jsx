export const RoomList = ({ rooms, selectedRoom, onSelectRoom, onCreateRoom }) => {
  return (
    <div className="w-80 bg-whatsapp-darkBg border-r border-whatsapp-border flex flex-col">
      {/* Header */}
      <div className="p-4 border-b border-whatsapp-border">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-whatsapp-text">WhatsApp</h1>
          <button
            onClick={onCreateRoom}
            className="bg-whatsapp-primary text-black rounded-full p-2 hover:bg-green-500 transition"
            title="Create new chat"
          >
            ✎
          </button>
        </div>
      </div>

      {/* Rooms List */}
      <div className="flex-1 overflow-y-auto">
        {rooms.length === 0 ? (
          <div className="p-4 text-center text-whatsapp-textSecondary">
            <p>No conversations yet</p>
            <button
              onClick={onCreateRoom}
              className="mt-2 text-whatsapp-primary font-semibold hover:underline"
            >
              Create one
            </button>
          </div>
        ) : (
          rooms.map((room) => (
            <button
              key={room.id}
              onClick={() => onSelectRoom(room)}
              className={`w-full p-4 text-left border-b border-whatsapp-border hover:bg-whatsapp-lightBg transition ${
                selectedRoom?.id === room.id ? 'bg-whatsapp-lightBg' : ''
              }`}
            >
              <h3 className="font-semibold text-whatsapp-text truncate">{room.name}</h3>
              <p className="text-sm text-whatsapp-textSecondary truncate">
                {new Date(room.created_at).toLocaleDateString()}
              </p>
            </button>
          ))
        )}
      </div>
    </div>
  )
}
