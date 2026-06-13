use crate::{database::AppState, routes::dto};
use axum::{
    Json, Router,
    extract::{State, Path, Query},
    http::StatusCode,
    routing::{get, post, any},
    extract::ws::{WebSocketUpgrade, WebSocket, Message},
    response::{IntoResponse, Response},
};
use serde_json;
use futures_util::{StreamExt, SinkExt};
use bcrypt::{DEFAULT_COST, hash, verify};
use jsonwebtoken::{EncodingKey, DecodingKey, Header, Validation, encode, decode};
use tokio::sync::broadcast;
use uuid::Uuid;
use chrono::{Duration, Utc};

pub async fn chat_home() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "name": "Chatting App API",
        "version": "1.0.0",
        "endpoints": {
            "auth": {
                "POST /users": "Register a new user",
                "POST /login": "Login and get JWT token"
            },
            "users": {
                "GET /users/{user_id}": "Get user details",
                "PUT /users/{user_id}": "Update username",
                "DELETE /users/{user_id}": "Delete user"
            },
            "rooms": {
                "POST /room": "Create a room",
                "POST /room/join": "Join a room",
                "GET /rooms?user_id=": "List rooms for a user",
                "GET /room/{room_id}/members": "List members in a room"
            },
            "messages": {
                "POST /message": "Send a message",
                "GET /message?room_id=&user_id=": "Get messages in a room"
            },
            "websocket": {
                "WS /ws/{room_id}?token=": "Real-time chat"
            }
        }
    }))
}


pub async fn create_message(
    State(state): State<AppState>,
    Json(request): Json<dto::CreateMessageRequest>,
) -> Result<Json<dto::MessageResponse>, StatusCode> {
    let id = Uuid::new_v4();
    let timestamp = Utc::now();

    let result = sqlx::query(
        r#"
        INSERT INTO messages (
            id,
            room_id,
            sender_id,
            content,
            created_at
        )
        VALUES ($1, $2, $3, $4, $5)
        "#
    )
    .bind(id)
    .bind(request.room_id)
    .bind(request.sender_id)
    .bind(&request.content)
    .bind(timestamp)
    .execute(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(dto::MessageResponse { id }))
}

pub async fn create_user(
    State(state): State<AppState>,
    Json(request): Json<dto::CreateUserRequest>,
) -> Result<Json<dto::AuthResponse>, StatusCode> {
    let id = Uuid::new_v4();
    let timestamp = Utc::now();

    let password_hash = hash(&request.password, DEFAULT_COST)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let result = sqlx::query(
        r#"
        INSERT INTO users (id, username, password_hash, created_at)
        VALUES ($1, $2, $3, $4)
        "#
    )
    .bind(id)
    .bind(&request.username)
    .bind(&password_hash)
    .bind(timestamp)
    .execute(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    let token = create_token(id).map_err(|e| {
        println!("JWT Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(dto::AuthResponse { id, token }))
}

pub async fn create_room(
    State(state): State<AppState>,
    Json(request): Json<dto::ChatRoomRequest>,
) -> Result<Json<dto::MessageResponse>, StatusCode> {
    let id = Uuid::new_v4();
    let timestamp = Utc::now();

    let result = sqlx::query(
        r#"
        INSERT INTO chat_rooms (
            id,
            name,
            created_at
        )
        VALUES ($1, $2, $3)
        "#
    )
    .bind(id)
    .bind(request.name)
    .bind(timestamp)
    .execute(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(dto::MessageResponse { id }))
}

pub async fn join_room(
    State(state): State<AppState>,
    Json(request): Json<dto::JoinRoomRequest>,
) -> Result<StatusCode, StatusCode> {
    let result = sqlx::query(
        r#"
        INSERT INTO room_members (
            room_id,
            user_id
        )
        VALUES ($1, $2)
        "#
    )
    .bind(request.room_id)
    .bind(request.user_id)
    .execute(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(StatusCode::CREATED)
}

pub async fn get_message(
    State(state): State<AppState>,
    Query(request): Query<dto::MessageRequest>,
) -> Result<StatusCode, StatusCode> {
    let result = sqlx::query(
        r#"
        SELECT m.*
        FROM messages m
        JOIN room_members rm
            ON rm.room_id = m.room_id
        WHERE m.room_id = $1
        AND rm.user_id = $2
        ORDER BY m.created_at ASC;
        "#
    )
    .bind(request.room_id)
    .bind(request.user_id)
    .fetch_all(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(StatusCode::CREATED)
}

pub fn create_token(user_id: Uuid) -> Result<String, jsonwebtoken::errors::Error> {
    let expiration = Utc::now()
        .checked_add_signed(Duration::hours(24))
        .unwrap()
        .timestamp() as usize;

    let claims = dto::Claims {
        sub: user_id.to_string(),
        exp: expiration,
    };

    let secret = std::env::var("JWT_SECRET").unwrap_or_else(|_| "secret".to_string());

    encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(secret.as_bytes()),
    )
}

pub async fn login(
    State(state): State<AppState>,
    Json(request): Json<dto::LoginRequest>,
) -> Result<Json<dto::AuthResponse>, StatusCode> {
    let row: (Uuid, String) = sqlx::query_as(
        r#"
        SELECT id, password_hash
        FROM users
        WHERE username = $1
        "#
    )
    .bind(&request.username)
    .fetch_one(&state.db)
    .await
    .map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::UNAUTHORIZED
    })?;

    let (user_id, password_hash) = row;

    let valid = verify(&request.password, &password_hash)
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if !valid {
        return Err(StatusCode::UNAUTHORIZED);
    }

    let token = create_token(user_id).map_err(|e| {
        println!("JWT Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(dto::AuthResponse { id: user_id, token }))
}



pub async fn handler(
    ws: WebSocketUpgrade,
    Path(room_id): Path<Uuid>,
    Query(params): Query<dto::WsParams>,
    State(state): State<AppState>,
) -> Response {
    let secret = std::env::var("JWT_SECRET").unwrap_or_else(|_| "secret".to_string());

    let token_data = decode::<dto::Claims>(
        &params.token,
        &DecodingKey::from_secret(secret.as_bytes()),
        &Validation::default(),
    );

    let user_id = match token_data {
        Ok(data) => match Uuid::parse_str(&data.claims.sub) {
            Ok(id) => id,
            Err(_) => return StatusCode::UNAUTHORIZED.into_response(),
        },
        Err(_) => return StatusCode::UNAUTHORIZED.into_response(),
    };

    ws.on_upgrade(move |socket| handle_socket(socket, user_id, room_id, state))
}

async fn handle_socket(socket: WebSocket, user_id: Uuid, room_id: Uuid, state: AppState) {
    let (mut sender, mut receiver) = socket.split();

    // 1. Get or create broadcast channel for this room
    let tx = {
        let mut rooms = state.rooms.lock().await;
        rooms.entry(room_id)
            .or_insert_with(|| broadcast::channel(32).0)
            .clone()
    };
    let mut rx = tx.subscribe();

    // 1. Snapshot last_seen_at BEFORE updating it
    let last_seen: (chrono::DateTime<Utc>,) = sqlx::query_as(
        "SELECT last_seen_at FROM room_members WHERE room_id = $1 AND user_id = $2"
    )
    .bind(room_id)
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .unwrap_or((chrono::DateTime::from_timestamp(0, 0).unwrap(),));

    // 2. Update last_seen_at to now IMMEDIATELY (before catch-up send)
    let _ = sqlx::query(
        "UPDATE room_members SET last_seen_at = now() WHERE room_id = $1 AND user_id = $2"
    )
    .bind(room_id)
    .bind(user_id)
    .execute(&state.db)
    .await;

    // 3. Catch-up using the SNAPSHOTTED timestamp, not the live one
    let missed = sqlx::query_as::<_, dto::MessageRow>(
        r#"
        SELECT id, room_id, sender_id, content, created_at
        FROM messages
        WHERE room_id = $1
          AND created_at > $2
        ORDER BY created_at ASC
        "#
    )
    .bind(room_id)
    .bind(last_seen.0)
    .fetch_all(&state.db)
    .await
    .unwrap_or_default();

    for msg in missed {
        let json = serde_json::to_string(&msg).unwrap();
        if sender.send(Message::Text(json.into())).await.is_err() {
            return;
        }
    }

    // 3. Update last_seen_at
    let _ = sqlx::query(
        "UPDATE room_members SET last_seen_at = now() WHERE room_id = $1 AND user_id = $2"
    )
    .bind(room_id)
    .bind(user_id)
    .execute(&state.db)
    .await;


    // 4. Spawn task: forward broadcasts from other users TO this socket
    let mut send_task = tokio::spawn(async move {
        while let Ok(msg) = rx.recv().await {
            if sender.send(Message::Text(msg.into())).await.is_err() {
                break;
            }
        }
    });

    let state2 = state.clone();

    // 5. Receive loop: read from this socket, persist, broadcast to room
    let mut recv_task = tokio::spawn(async move{
        while let Some(Ok(msg)) = receiver.next().await {
            match msg {
                Message::Text(text) => {
                    // Ignore control messages
                    if text.trim_start().starts_with('{') {
                        if let Ok(v) = serde_json::from_str::<serde_json::Value>(&text) {
                            if v.get("type").and_then(|t| t.as_str()) == Some("ping") {
                                continue;
                            }
                        }
                    }

                    // Persist to DB
                    let msg_id = Uuid::new_v4();
                    let timestamp = Utc::now();
                    let _ = sqlx::query(
                        r#"INSERT INTO messages (id, room_id, sender_id, content, created_at)
                           VALUES ($1, $2, $3, $4, $5)"#
                    )
                    .bind(msg_id)
                    .bind(room_id)
                    .bind(user_id)
                    .bind(text.as_str())
                    .bind(timestamp)
                    .execute(&state.db.clone())
                    .await;

                    // Broadcast to all subscribers in this room (including sender)
                    let payload = serde_json::json!({
                        "id": msg_id,
                        "room_id": room_id,
                        "sender_id": user_id,
                        "content": text.as_str(),
                        "created_at": timestamp,
                    }).to_string();

                    let _ = tx.send(payload);
                }
                Message::Ping(payload) => {
                    // axum handles pong automatically, but just in case
                    let _ = tx.send(serde_json::json!({"type":"pong"}).to_string());
                    let _ = payload;
                }
                Message::Close(_) => break,
                _ => {}
            }
        }
    });

    // 6. If either task exits, abort the other
    tokio::select! {
        _ = &mut send_task => recv_task.abort(),
        _ = &mut recv_task => send_task.abort(),
    }

    // 7. Update last_seen_at on disconnect
    let _ = sqlx::query(
        "UPDATE room_members SET last_seen_at = now() WHERE room_id = $1 AND user_id = $2"
    )
    .bind(room_id)
    .bind(user_id)
    .execute(&state2.db)
    .await;
}

pub async fn get_user_rooms(
    State(state): State<AppState>,
    Query(params): Query<dto::UserIdQuery>,
) -> Result<Json<Vec<dto::RoomRow>>, StatusCode> {
    let rooms = sqlx::query_as::<_, dto::RoomRow>(
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

pub async fn get_room_members(
    State(state): State<AppState>,
    Path(room_id): Path<Uuid>,
) -> Result<Json<Vec<dto::MemberRow>>, StatusCode> {
    let members = sqlx::query_as::<_, dto::MemberRow>(
        r#"
        SELECT rm.user_id, u.username, rm.last_seen_at
        FROM room_members rm
        JOIN users u ON u.id = rm.user_id
        WHERE rm.room_id = $1
        ORDER BY u.username ASC
        "#
    )
    .bind(room_id)
    .fetch_all(&state.db)
    .await
    .map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(members))
}

pub async fn delete_user(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> Result<StatusCode, StatusCode> {
    let result = sqlx::query("DELETE FROM users WHERE id = $1")
        .bind(user_id)
        .execute(&state.db)
        .await
        .map_err(|e| {
            println!("DB Error: {:?}", e);
            StatusCode::INTERNAL_SERVER_ERROR
        })?;

    if result.rows_affected() == 0 {
        return Err(StatusCode::NOT_FOUND);
    }

    Ok(StatusCode::NO_CONTENT)
}


pub async fn modify_user(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
    Json(body): Json<dto::ModifyName>,
) -> Result<StatusCode, StatusCode> {
    let result = sqlx::query("UPDATE users SET username=$1 WHERE id=$2")
        .bind(&body.new_name)
        .bind(user_id)
        .execute(&state.db)
        .await
        .map_err(|e| {
            println!("DB Error: {:?}", e);
            StatusCode::INTERNAL_SERVER_ERROR
        })?;

    if result.rows_affected() == 0 {
        return Err(StatusCode::NOT_FOUND);
    }

    Ok(StatusCode::NO_CONTENT)
}

pub async fn get_user(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> Result<Json<dto::UserRow>, StatusCode> {
    let user = sqlx::query_as::<_, dto::UserRow>(
        "SELECT id, username, created_at FROM users WHERE id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|e| {
        println!("DB Error: {:?}", e);
        StatusCode::NOT_FOUND
    })?;

    Ok(Json(user))
}