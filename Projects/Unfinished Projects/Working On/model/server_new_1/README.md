# C++ HTTP Server — Online Code Editor Backend

A single-binary HTTP server built from scratch in C++ with no external
frameworks. Handles user auth and remote code execution for an online
code editor.

---

## Project layout

```
server/
├── main.cpp                   ← entry point; wires everything together
├── Makefile
└── src/
    ├── User.hpp               ← User model (username + passwordHash)
    ├── Hash.hpp               ← Polynomial rolling hash
    ├── Json.hpp               ← Flat JSON container + parser
    ├── Status.hpp             ← HTTP status reason phrases
    ├── HttpRequest.hpp        ← Parsed HTTP request struct
    ├── HttpResponse.hpp       ← Response struct + convenience builders
    ├── HttpParser.hpp         ← Reads raw bytes from socket → HttpRequest
    ├── UserRepository.hpp     ← Abstract base class for user storage
    ├── SQLiteUserRepository.hpp ← SQLite implementation
    ├── SessionManager.hpp     ← In-memory token → username store
    ├── Auth.hpp               ← AuthRequest / AuthResponse DTOs
    ├── AuthService.hpp        ← register + login business logic
    ├── CodeRunner.hpp         ← Executes code via popen (python/c/cpp/bash)
    ├── Router.hpp             ← Stores GET/POST routes, dispatches requests
    ├── Routes.hpp             ← All route handlers (register/login/code/health)
    └── Connection.hpp         ← TCP socket accept loop
```

---

## Build

```bash
# requires: g++, libsqlite3-dev
sudo apt install libsqlite3-dev   # Ubuntu/Debian
brew install sqlite3              # macOS

make          # produces ./server
make clean    # remove binary and temp files
```

---

## Run

```bash
./server      # listens on port 8080
```

The SQLite database `users.db` is created automatically in the working
directory on first run.

---

## API

### POST /register

```json
{ "username": "sai", "password": "secret" }
```

Response `201 Created`:
```json
{ "message": "user created", "token": "<32-char token>" }
```

### POST /login

```json
{ "username": "sai", "password": "secret" }
```

Response `200 OK`:
```json
{ "message": "login successful", "token": "<32-char token>" }
```

### POST /code  *(requires auth)*

Header: `Authorization: Bearer <token>`

```json
{ "language": "python", "code": "print('hello world')" }
```

Response `200 OK`:
```json
{ "status": "success", "output": "hello world", "exitCode": 0 }
```

Supported languages: `python`, `c`, `cpp`, `bash`

### GET /health

```json
{ "status": "ok" }
```

---

## Data flow

```
Client
  │
  ▼
Connection::run()           — accept() loop, one connection at a time
  │
  ▼
HttpParser::parseRequest()  — reads socket bytes → HttpRequest
  │
  ▼
Router::handle()            — matches method + path → handler function
  │
  ├─ POST /register → AuthService::registerUser()
  │                       Hash password → SQLite INSERT → create session token
  │
  ├─ POST /login    → AuthService::login()
  │                       Hash password → SQLite lookup → compare → create token
  │
  ├─ POST /code     → validate Bearer token → CodeRunner::runCode()
  │                       write temp file → exec via popen → capture output
  │
  └─ GET  /health   → { "status": "ok" }
  │
  ▼
HttpResponse::toString()    — serialize → send() back to client
```

---

## Security notes (for production)

- The hash is a polynomial rolling hash, good for learning.
  For production use bcrypt / Argon2 (via libsodium or OpenSSL).
- Sessions are in-memory and lost on restart.
  Use a persistent store (Redis / SQLite sessions table) for production.
- Code execution uses `popen` with a `timeout 10` guard but no sandboxing.
  Wrap with Docker, nsjail, or seccomp for real isolation.
- The server handles one connection at a time (single-threaded).
  Add `std::thread` or `epoll` for concurrency.
