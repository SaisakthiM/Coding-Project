# Quick Start Guide

## 1. Start Your Rust Backend

Make sure your backend is running:
```bash
cd chatting-app
cargo run
# Backend should be available at http://localhost:8000
```

## 2. Install Dependencies

```bash
npm install
```

## 3. Configure Backend URL (Optional)

By default, the frontend looks for the backend at `http://localhost:8000`.

If your backend is on a different URL, create `.env.local`:
```
VITE_API_URL=http://your-backend-url:port
```

## 4. Start Development Server

```bash
npm run dev
```

The app will open at http://localhost:3000

## 5. Use the App

1. **Register** - Create a new account with username and password
2. **Login** - Sign in with your credentials
3. **Create/Join Rooms** - Create a new chat room or join an existing one with a room ID
4. **Start Chatting** - Real-time messages powered by WebSocket

## Features Overview

### Sidebar (Left)
- **WhatsApp Header** - App title with create chat button
- **Room List** - All your joined chat rooms
- Click any room to open it

### Chat Area (Right)
- **Header** - Room name, member count, settings, logout
- **Messages** - Conversation history
- **Input** - Send messages in real-time

### Modals
- **Create Room** - Give it a name, you're automatically added
- **Join Room** - Paste a room ID to join
- **Members** - See who's in the room and their online status

## Troubleshooting

### "Cannot GET /api/..."
Make sure your backend is running on the correct port.

### WebSocket won't connect
- Verify your backend supports WebSocket upgrades
- Check that JWT token is valid
- Ensure room ID is a valid UUID

### Messages not appearing
- Check browser console for errors
- Verify WebSocket connection is established
- Make sure you're a member of the room

## File Structure Quick Reference

```
src/
├── pages/Chat.jsx          - Main chat interface
├── pages/Login.jsx         - Auth page
├── components/             - Reusable UI parts
├── services/api.js         - API calls
├── services/websocket.js   - WebSocket logic
└── context/AuthContext.jsx - Auth state
```

## Next Steps

- **Customize Colors** - Edit `tailwind.config.js`
- **Add Features** - Create new components in `src/components/`
- **Deploy** - Run `npm run build` and deploy `dist/` folder
- **Backend Integration** - Adjust API URLs in `src/services/api.js`

Happy Chatting! 💚
