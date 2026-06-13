# Backend Fixes Guide - Timestamp & Database Issues

## Problem 1: Timestamp Mismatch Error

```
DB Error: ColumnDecode { index: "\"created_at\"", 
source: "mismatched types; Rust type 
`chrono::datetime::DateTime<chrono::offset::utc::Utc>` 
(as SQL type `TIMESTAMPTZ`) is not compatible with SQL type `TIMESTAMP`" }
```

### Root Cause
Your PostgreSQL database has columns with type `TIMESTAMP` (without timezone), but your Rust code expects `TIMESTAMPTZ` (with timezone).

### Solution 1: Change Rust Code (Recommended)

In your struct definitions (likely in `src/routes/dto.rs` or `src/routes/classes.rs`):

**Before:**
```rust
#[derive(sqlx::FromRow, Serialize, Deserialize)]
pub struct Message {
    pub id: Uuid,
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
    pub created_at: DateTime<Utc>,  // ❌ Expects TIMESTAMPTZ
}
```

**After:**
```rust
use chrono::NaiveDateTime;

#[derive(sqlx::FromRow, Serialize, Deserialize)]
pub struct Message {
    pub id: Uuid,
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
    pub created_at: NaiveDateTime,  // ✅ Works with TIMESTAMP
}
```

Apply this to ALL structs that have `created_at` timestamps:
- `Message`
- `User`
- `ChatRoom`
- `RoomMember`
- Any other timestamp field

### Solution 2: Change Database (Alternative)

If you prefer timestamps with timezone, alter your database:

```sql
-- For messages table
ALTER TABLE messages 
ALTER COLUMN created_at TYPE timestamptz USING created_at::timestamptz;

-- For users table
ALTER TABLE users 
ALTER COLUMN created_at TYPE timestamptz USING created_at::timestamptz;

-- For chat_rooms table
ALTER TABLE chat_rooms 
ALTER COLUMN created_at TYPE timestamptz USING created_at::timestamptz;

-- For room_members table
ALTER TABLE room_members 
ALTER COLUMN last_seen_at TYPE timestamptz USING last_seen_at::timestamptz;
```

---

## Problem 2: 404/500 Errors on Room Routes

```
Failed to load resource: the server responded with a status of 404 (Not Found)
Failed to load resource: the server responded with a status of 500 (Internal Server Error)
```

### Common Causes & Fixes

#### Issue A: Route Not Registered

Check your `src/routes/mod.rs`:

```rust
pub fn room() -> Router {
    Router::new()
        .route("/room", post(handlers::create_room))
        .route("/room/:room_id/members", get(handlers::get_room_members))
}

pub fn room_routes() -> Router {
    Router::new()
        .route("/rooms", get(handlers::get_user_rooms))  // ← Note: plural "rooms"
        .route("/room/join", post(handlers::join_room))
}
```

Make sure all these routes are registered in `main.rs`:
```rust
let app = Router::new()
    .merge(routes::room())
    .merge(routes::room_routes())
    .merge(routes::joinRoom())  // Make sure this exists
    // ... other routes
    .with_state(state)
    .layer(cors);
```

#### Issue B: Database Query Failure

If routes exist but return 500, check your SQL queries. Common issue in `GET /rooms`:

**Original (possibly failing):**
```rust
pub async fn get_user_rooms(
    State(state): State<AppState>,
    Query(params): Query<UserIdQuery>,
) -> Result<Json<Vec<RoomRow>>, StatusCode> {
    let rooms = sqlx::query_as::<_, RoomRow>(
        r#"
        SELECT cr.id, cr.name, cr.created_at
        FROM chat_rooms cr
        JOIN room_members rm ON rm.room_id = cr.id
        WHERE rm.user_id = $1
        ORDER BY cr.created_at DESC
        "#
    )
    .bind(params.user_id)
    .fetch_all(&state.db)
    .await
    .map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(rooms))
}
```

**Fixed (with proper struct matching):**
```rust
#[derive(sqlx::FromRow, Serialize)]
pub struct RoomRow {
    pub id: Uuid,
    pub name: String,
    pub created_at: NaiveDateTime,  // ← Changed from DateTime<Utc>
}

pub async fn get_user_rooms(
    State(state): State<AppState>,
    Query(params): Query<UserIdQuery>,
) -> Result<Json<Vec<RoomRow>>, StatusCode> {
    let rooms = sqlx::query_as::<_, RoomRow>(
        r#"
        SELECT cr.id, cr.name, cr.created_at
        FROM chat_rooms cr
        JOIN room_members rm ON rm.room_id = cr.id
        WHERE rm.user_id = $1
        ORDER BY cr.created_at DESC
        "#
    )
    .bind(params.user_id)
    .fetch_all(&state.db)
    .await
    .map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(rooms))
}
```

---

## Complete Fix Checklist

- [ ] Identify all timestamp-using structs
- [ ] Change `DateTime<Utc>` → `NaiveDateTime` in all structs
- [ ] Update `Cargo.toml` if needed (make sure `chrono` includes `NaiveDateTime`)
- [ ] Rebuild: `cargo build`
- [ ] Restart server: `cargo run`
- [ ] Test `/register` endpoint
- [ ] Test `/login` endpoint
- [ ] Test `/room` (create room) endpoint
- [ ] Test `/rooms?user_id=...` endpoint
- [ ] Test WebSocket connection

---

## Files to Update

Based on typical structure, modify these files:

1. **src/routes/dto.rs** or **src/routes/classes.rs**
   - Find all struct definitions with `created_at` or timestamp fields
   - Replace `DateTime<Utc>` with `NaiveDateTime`

2. **src/main.rs**
   - Add CORS layer (if not already done)
   - Verify all route merges are present

3. **Cargo.toml**
   - Ensure `chrono` is included with needed features

---

## Testing Commands

After fixes, test with curl:

```bash
# Register
curl -X POST http://localhost:8000/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"password123"}'

# Login
curl -X POST http://localhost:8000/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"password123"}'

# Get user rooms (replace with real user_id)
curl -X GET "http://localhost:8000/rooms?user_id=550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Health check
curl http://localhost:8000/health
```

---

## Debugging Tips

1. **Check backend logs**
   ```
   DB Error: ColumnDecode { ... }  ← Type mismatch
   DB Error: relation "..." does not exist  ← Wrong table name
   Failed to decode column "..."  ← Field name mismatch
   ```

2. **Verify database schema**
   ```sql
   \d messages;  -- In psql
   ```
   Check if columns are `timestamp` or `timestamptz`

3. **Use `println!` debugging**
   ```rust
   println!("Query result: {:?}", result);
   ```

4. **Check CORS is enabled**
   - Frontend requests should include proper headers
   - Backend should respond with `Access-Control-Allow-Origin`

---

## Quick Reference

| Error | Fix |
|-------|-----|
| `mismatched types` timestamp | Change `DateTime<Utc>` → `NaiveDateTime` |
| 404 on `/rooms` | Check route is registered with plural name |
| 500 on room endpoints | Check struct fields match SQL columns exactly |
| CORS error | Add `CorsLayer::permissive()` to router |
| Type decode error | Verify struct field names match SQL column names |

---

## Still Having Issues?

1. Check the server console output for the exact error
2. Compare your structs with the SQL query SELECT fields
3. Make sure all `Uuid` fields match UUID columns in DB
4. Verify token is being sent in Authorization header
5. Check that user exists in database before querying their rooms

Good luck! 🚀
