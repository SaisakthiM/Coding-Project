# WhatsApp Backend - Rust/Axum

Complete, production-ready WhatsApp backend built with Rust, Axum, and PostgreSQL.

## Features

✅ User authentication with JWT  
✅ Real-time WebSocket messaging  
✅ User profiles and settings  
✅ Chat rooms and members management  
✅ CORS enabled for frontend  
✅ Proper error handling  
✅ Database migrations included  

## Quick Start

### Prerequisites
- Rust 1.70+
- PostgreSQL 12+
- Docker (optional, for PostgreSQL)

### Setup

1. **Clone/Extract**
```bash
cd chatting-app-fixed
```

2. **Create .env**
```bash
cp .env.example .env
```

3. **Start PostgreSQL** (if using Docker)
```bash
docker run -d \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=whatsapp \
  -p 5432:5432 \
  postgres:15
```

4. **Build & Run**
```bash
cargo build
cargo run
```

Server runs on `http://localhost:8000`

## API Endpoints

### Authentication
```
POST   /users              - Register
POST   /login              - Login
```

### User Profile
```
GET    /profile/{user_id} - Get profile
PUT    /profile/{user_id} - Update profile
```

### Settings
```
GET    /settings/{user_id} - Get settings
PUT    /settings/{user_id} - Update settings
```

### Chat Rooms
```
POST   /room               - Create room
POST   /room/join          - Join room
GET    /rooms?user_id=     - List user rooms
GET    /room/{id}/members  - Get members
```

### Messages
```
POST   /message            - Send message
GET    /message            - Get messages
```

### WebSocket
```
WS     /ws/{room_id}       - Real-time chat
```

### Health
```
GET    /health             - Health check
```

## Environment Variables

```
DATABASE_URL=postgresql://user:pass@localhost/db
JWT_SECRET=your-secret-key
```

## Database

Automatic schema creation on startup. Tables:
- users
- chat_rooms
- room_members
- messages
- user_settings

## Testing

Register:
```bash
curl -X POST http://localhost:8000/users \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

Login:
```bash
curl -X POST http://localhost:8000/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

## CORS

Enabled for all origins - change in production!

## License

MIT
