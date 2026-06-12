# CORS Error Fix - WhatsApp Chat Backend

## Problem
```
Access to XMLHttpRequest at 'http://localhost:8000/users' from origin 'http://localhost:3000' 
has been blocked by CORS policy
```

This happens because the **frontend** (port 3000) and **backend** (port 8000) are on different origins.

---

## Solution: Add CORS Middleware to Rust Backend

### Step 1: Update `Cargo.toml`

Add the CORS dependency:

```toml
[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }
sqlx = { version = "0.7", features = ["runtime-tokio-native-tls", "postgres"] }
bcrypt = "0.15"
jsonwebtoken = "9"
uuid = { version = "1", features = ["v4", "serde"] }
chrono = "0.4"
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
futures-util = "0.3"
dotenvy = "0.15"
tower-http = { version = "0.5", features = ["cors"] }  # 👈 ADD THIS
tower = "0.4"
```

### Step 2: Update `src/main.rs`

Add CORS middleware to your router:

```rust
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let state = database::connect_db().await;
    database::init_database(&state.db)
        .await
        .expect("Failed to initialize database");

    // ✨ Add CORS layer
    let cors = CorsLayer::permissive();

    let app = Router::new()
        .merge(routes::home())
        .merge(routes::message())
        .merge(routes::user())
        .merge(routes::room())
        .merge(routes::joinRoom())
        .merge(routes::getMessage())
        .merge(routes::login())
        .merge(routes::ws())
        .merge(routes::room_routes())
        .with_state(state)
        .layer(cors)  // 👈 ADD THIS LINE
        ;

    println!("DATABASE_URL = {:?}", env::var("DATABASE_URL"));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:8000")
        .await
        .unwrap();

    println!("Server running on http://localhost:8000");

    axum::serve(listener, app).await.unwrap();
}
```

### Step 3: Rebuild and Restart

```bash
cargo build
cargo run
```

---

## CORS Modes

### 1. **Permissive (Development)**
```rust
let cors = CorsLayer::permissive();
```
✅ Allows requests from ANY origin
⚠️ Use only for development!

### 2. **Very Permissive (Development)**
```rust
let cors = CorsLayer::very_permissive();
```
✅ Similar to permissive, with more lenient checks

### 3. **Restrictive (Production)**
```rust
use tower_http::cors::{CorsLayer, AllowOrigin};
use http::Method;

let cors = CorsLayer::new()
    .allow_origin(AllowOrigin::exact("http://localhost:3000".parse().unwrap()))
    .allow_methods([Method::GET, Method::POST, Method::PUT, Method::DELETE])
    .allow_headers(tower_http::cors::Any);
```
✅ Only allows your frontend origin
✅ Recommended for production

For production with deployed frontend:
```rust
.allow_origin(AllowOrigin::exact("https://your-domain.com".parse().unwrap()))
```

---

## Testing the Fix

1. Restart your backend with CORS enabled
2. Open http://localhost:3000 in browser
3. Try to register/login
4. If it works, CORS is fixed! ✅

---

## Common Issues

### Still getting CORS error?
- Make sure backend is running on correct port
- Restart backend after adding CORS
- Check browser console for exact error
- Verify `Cargo.toml` has `tower-http` dependency

### Got a different error?
- Check `/users` endpoint exists in backend
- Verify request method is POST
- Check JSON body format
- Look at backend console logs

### What about WebSocket?
- WebSocket doesn't need CORS, it uses its own upgrade mechanism
- But still good practice to have CORS enabled for HTTP endpoints

---

## How CORS Works

1. **Browser sends preflight request** (OPTIONS)
   - Asks server: "Can I make a POST request from localhost:3000?"

2. **Server responds with CORS headers**
   - `Access-Control-Allow-Origin: *`
   - `Access-Control-Allow-Methods: GET, POST, PUT, DELETE`
   - `Access-Control-Allow-Headers: Content-Type, Authorization`

3. **Browser allows actual request**
   - If server headers match, real request is sent
   - If not, request is blocked

That's why you need CORS middleware! 🔐

---

## Reference Links

- [MDN CORS Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Tower HTTP CORS Docs](https://docs.rs/tower-http/latest/tower_http/cors/)
- [Axum Tutorial](https://docs.rs/axum/latest/axum/)
