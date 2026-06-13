# WhatsApp - Modern MUI React Frontend

A modern, professional WhatsApp-like chat application built with Material-UI (MUI) and React.

## Features

✨ Modern Material-UI Design  
🔐 Secure JWT Authentication  
👤 User Profiles & Settings  
📤 File Upload with MinIO  
💬 Real-time WebSocket Chat  
🌙 Dark Theme by Default  
📱 Fully Responsive  

## Installation

```bash
npm install
npm run dev
```

## API Integration

Make sure your backend is running on `http://localhost:8000`

## Project Structure

```
src/
├── pages/
│   ├── LoginPage.jsx
│   ├── ChatPage.jsx
│   └── ProfilePage.jsx
├── components/
├── services/
│   ├── api.js
│   └── websocket.js
├── context/
│   └── AuthContext.jsx
├── hooks/
│   └── useAuth.js
├── App.jsx
└── main.jsx
```

## Building

```bash
npm run build
```

## Requirements

- Node.js 16+
- Backend running on localhost:8000
- MinIO/S3 for file uploads

## Environment

Create `.env.local`:
```
VITE_API_URL=http://localhost:8000
```
