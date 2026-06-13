# WhatsApp - React Frontend

A beautiful, WhatsApp-like chat application frontend built with React, Tailwind CSS, and Vite.

## Features

✨ **Modern WhatsApp UI** - Dark theme with WhatsApp green accents
🔐 **Authentication** - User registration and login with JWT tokens
💬 **Real-time Messaging** - WebSocket-powered instant chat
🏘️ **Chat Rooms** - Create and join multiple chat rooms
👥 **Member Management** - See online/offline status of members
📱 **Responsive Design** - Works on desktop and mobile devices
🎨 **Modular Architecture** - Clean component-based structure with React Router

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── ChatHeader.jsx   # Chat room header
│   ├── MembersList.jsx  # Members modal
│   ├── MessageInput.jsx # Message input form
│   ├── MessageList.jsx  # Message display
│   └── RoomList.jsx     # Chat rooms sidebar
├── context/
│   └── AuthContext.jsx  # Global auth state
├── hooks/
│   └── useAuth.js       # Auth hook
├── pages/               # Page components
│   ├── Chat.jsx         # Main chat page
│   └── Login.jsx        # Login/Register page
├── services/
│   ├── api.js           # API calls to backend
│   └── websocket.js     # WebSocket service
├── App.jsx              # Main app with routing
├── main.jsx             # Entry point
└── index.css            # Global styles

vite.config.js           # Vite configuration
tailwind.config.js       # Tailwind CSS configuration
postcss.config.js        # PostCSS configuration
```

## Setup Instructions

### Prerequisites
- Node.js 16+ installed
- Backend running on http://localhost:8000

### Installation

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Configure environment (optional)**
   ```bash
   cp .env.example .env.local
   ```
   Edit `.env.local` to point to your backend:
   ```
   VITE_API_URL=http://localhost:8000
   ```

3. **Start development server**
   ```bash
   npm run dev
   ```
   The app will be available at http://localhost:3000

4. **Build for production**
   ```bash
   npm run build
   ```
   The optimized build will be in the `dist/` folder.

## API Endpoints Used

The frontend communicates with the Rust backend via these endpoints:

### Authentication
- `POST /users` - Register new user
- `POST /login` - Login user

### Users
- `GET /users/{user_id}` - Get user details
- `PUT /users/{user_id}` - Update username
- `DELETE /users/{user_id}` - Delete user

### Rooms
- `POST /room` - Create chat room
- `POST /room/join` - Join existing room
- `GET /rooms?user_id=` - Get user's rooms
- `GET /room/{room_id}/members` - Get room members

### Messages
- `POST /message` - Send message (HTTP)
- `WS /ws/{room_id}?token=` - WebSocket for real-time chat

## Key Components

### AuthContext
Manages user authentication state globally:
- Stores user data and JWT token
- Persists auth data in localStorage
- Provides login/logout functions

### MessageList
Displays chat messages with:
- Sender identification (own vs others)
- Different styling for sent/received
- Timestamps
- Auto-scroll to latest message

### WebSocketService
Handles real-time communication:
- Connects to WebSocket endpoint with JWT
- Manages message events
- Handles reconnection and buffering
- Supports custom event listeners

### RoomList
Sidebar showing:
- All user's chat rooms
- Room selection
- Create/join room actions

### ChatHeader
Shows room information:
- Room name
- Member count
- Settings and logout buttons

## User Flow

1. **Authentication**
   - User registers or logs in
   - Backend returns JWT token
   - Token stored in localStorage

2. **Chat Room Selection**
   - User sees list of joined rooms
   - Can create new room or join existing

3. **Real-time Messaging**
   - WebSocket connects with JWT
   - Messages sent/received in real-time
   - Messages persisted to database
   - Missed messages loaded on connection

4. **Room Management**
   - View members and online status
   - Create new chat rooms
   - Join rooms by ID

## Styling

The app uses Tailwind CSS with custom WhatsApp color scheme:
- Primary: `#25D366` (WhatsApp Green)
- Dark backgrounds for OLED optimization
- Smooth transitions and hover states
- Custom scrollbar styling

## Environment Variables

Create a `.env.local` file:

```
VITE_API_URL=http://localhost:8000
```

## Development Tips

- **Hot Module Replacement**: Changes are reflected instantly
- **API Debugging**: Check Network tab in DevTools
- **WebSocket Debugging**: Use browser's DevTools Network tab, filter by WS
- **Auth Issues**: Check localStorage for token persistence

## Troubleshooting

### "Connection refused" errors
- Ensure backend is running on the configured port
- Check VITE_API_URL environment variable

### WebSocket connection fails
- Verify JWT token is valid
- Check room ID format (should be UUID)
- Ensure backend allows WebSocket upgrades

### Messages not showing
- Check browser console for errors
- Verify you're a member of the room
- Ensure WebSocket is connected

## Building for Production

```bash
npm run build
```

The `dist/` folder contains optimized static files ready for deployment.

## License

MIT

## Notes

- Backend must be running for the app to function
- All data is persisted in the backend database
- Real-time features require WebSocket support
- JWT tokens expire after 24 hours (configure in backend)
