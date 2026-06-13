use axum::{
    extract::{Path, Query, State, ws::WebSocket},
    http::StatusCode,
    Json,
};
use serde_json::json;
use sqlx::Row;
use uuid::Uuid;
use chrono::Utc;

use crate::{
    database::AppState,
    models::*,
};

use super::utils::{hash_password, verify_password, create_token};

// ===== Health Check =====
pub async fn health() -> &'static str {
    "OK"
}

// ===== User Management =====
pub async fn create_user(
    State(state): State<AppState>,
    Json(payload): Json<CreateUserRequest>,
) -> Result<Json<AuthResponse>, (StatusCode, String)> {
    let password_hash = hash_password(&payload.password)
        .map_err(|_| (StatusCode::INTERNAL_SERVER_ERROR, "Failed to hash password".to_string()))?;

    let user_id = Uuid::new_v4();
    
    sqlx::query(
        "INSERT INTO users (id, username, password_hash) VALUES ($1, $2, $3)"
    )
    .bind(&user_id)
    .bind(&payload.username)
    .bind(&password_hash)
    .execute(&state.db)
    .await
    .map_err(|e| {
        let msg = if e.to_string().contains("unique constraint") {
            "Username already exists".to_string()
        } else {
            "Failed to create user".to_string()
        };
        (StatusCode::CONFLICT, msg)
    })?;

    // Create default settings
    sqlx::query(
        "INSERT INTO user_settings (user_id, theme, language, notifications) VALUES ($1, $2, $3, $4)"
    )
    .bind(&user_id)
    .bind("dark")
    .bind("en")
    .bind(true)
    .execute(&state.db)
    .await
    .ok();

    let token = create_token(&user_id.to_string())
        .map_err(|_| (StatusCode::INTERNAL_SERVER_ERROR, "Failed to create token".to_string()))?;

    Ok(Json(AuthResponse {
        id: user_id,
        username: payload.username,
        token,
    }))
}

pub async fn login(
    State(state): State<AppState>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, (StatusCode, String)> {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE username = $1"
    )
    .bind(&payload.username)
    .fetch_one(&state.db)
    .await
    .map_err(|_| (StatusCode::UNAUTHORIZED, "Invalid credentials".to_string()))?;

    verify_password(&payload.password, &user.password_hash)
        .map_err(|_| (StatusCode::UNAUTHORIZED, "Invalid credentials".to_string()))?;

    let token = create_token(&user.id.to_string())
        .map_err(|_| (StatusCode::INTERNAL_SERVER_ERROR, "Failed to create token".to_string()))?;

    Ok(Json(AuthResponse {
        id: user.id,
        username: user.username,
        token,
    }))
}

pub async fn get_user(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> Result<Json<UserResponse>, StatusCode> {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::NOT_FOUND)?;

    Ok(Json(UserResponse {
        id: user.id,
        username: user.username,
        bio: user.bio,
        avatar_url: user.avatar_url,
        created_at: user.created_at,
    }))
}

// ===== Profile Management =====
pub async fn get_profile(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> Result<Json<UserResponse>, StatusCode> {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::NOT_FOUND)?;

    Ok(Json(UserResponse {
        id: user.id,
        username: user.username,
        bio: user.bio,
        avatar_url: user.avatar_url,
        created_at: user.created_at,
    }))
}

pub async fn update_profile(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
    Json(payload): Json<UpdateProfileRequest>,
) -> Result<Json<UserResponse>, StatusCode> {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::NOT_FOUND)?;

    let username = payload.username.unwrap_or(user.username.clone());
    let bio = payload.bio.or(user.bio.clone());

    sqlx::query(
        "UPDATE users SET username = $1, bio = $2 WHERE id = $3"
    )
    .bind(&username)
    .bind(&bio)
    .bind(user_id)
    .execute(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(UserResponse {
        id: user.id,
        username,
        bio,
        avatar_url: user.avatar_url,
        created_at: user.created_at,
    }))
}

// ===== Settings Management =====
pub async fn get_settings(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> Result<Json<SettingsResponse>, StatusCode> {
    let settings = sqlx::query_as::<_, UserSettings>(
        "SELECT * FROM user_settings WHERE user_id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::NOT_FOUND)?;

    Ok(Json(SettingsResponse {
        theme: settings.theme,
        language: settings.language,
        notifications: settings.notifications,
    }))
}

pub async fn update_settings(
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
    Json(payload): Json<UpdateSettingsRequest>,
) -> Result<Json<SettingsResponse>, StatusCode> {
    let settings = sqlx::query_as::<_, UserSettings>(
        "SELECT * FROM user_settings WHERE user_id = $1"
    )
    .bind(user_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::NOT_FOUND)?;

    let theme = payload.theme.unwrap_or(settings.theme);
    let language = payload.language.unwrap_or(settings.language);
    let notifications = payload.notifications.unwrap_or(settings.notifications);

    sqlx::query(
        "UPDATE user_settings SET theme = $1, language = $2, notifications = $3 WHERE user_id = $4"
    )
    .bind(&theme)
    .bind(&language)
    .bind(notifications)
    .bind(user_id)
    .execute(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(SettingsResponse {
        theme,
        language,
        notifications,
    }))
}

// ===== Room Management =====
pub async fn create_room(
    State(state): State<AppState>,
    Json(payload): Json<CreateRoomRequest>,
) -> Result<Json<RoomResponse>, StatusCode> {
    let room_id = Uuid::new_v4();

    sqlx::query(
        "INSERT INTO chat_rooms (id, name) VALUES ($1, $2)"
    )
    .bind(&room_id)
    .bind(&payload.name)
    .execute(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let room = sqlx::query_as::<_, ChatRoom>(
        "SELECT * FROM chat_rooms WHERE id = $1"
    )
    .bind(&room_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(RoomResponse {
        id: room.id,
        name: room.name,
        created_at: room.created_at,
    }))
}

pub async fn join_room(
    State(state): State<AppState>,
    Json(payload): Json<JoinRoomRequest>,
) -> Result<StatusCode, StatusCode> {
    sqlx::query(
        "INSERT INTO room_members (room_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING"
    )
    .bind(payload.room_id)
    .bind(payload.user_id)
    .execute(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(StatusCode::OK)
}

pub async fn get_user_rooms(
    State(state): State<AppState>,
    Query(params): Query<UserIdQuery>,
) -> Result<Json<Vec<RoomResponse>>, StatusCode> {
    let rooms = sqlx::query_as::<_, ChatRoom>(
        r#"
        SELECT DISTINCT cr.* FROM chat_rooms cr
        JOIN room_members rm ON rm.room_id = cr.id
        WHERE rm.user_id = $1
        ORDER BY cr.created_at DESC
        "#
    )
    .bind(params.user_id)
    .fetch_all(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let response = rooms.into_iter().map(|r| RoomResponse {
        id: r.id,
        name: r.name,
        created_at: r.created_at,
    }).collect();

    Ok(Json(response))
}

pub async fn get_room_members(
    State(state): State<AppState>,
    Path(room_id): Path<Uuid>,
) -> Result<Json<Vec<MemberResponse>>, StatusCode> {
    let members = sqlx::query(
        r#"
        SELECT u.id, u.username, u.avatar_url, rm.joined_at
        FROM users u
        JOIN room_members rm ON rm.user_id = u.id
        WHERE rm.room_id = $1
        ORDER BY rm.joined_at
        "#
    )
    .fetch_all(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let response = members.into_iter().map(|row| MemberResponse {
        user_id: row.get(0),
        username: row.get(1),
        avatar_url: row.get(2),
        joined_at: row.get(3),
    }).collect();

    Ok(Json(response))
}

// ===== Messages =====
pub async fn send_message(
    State(state): State<AppState>,
    Json(payload): Json<SendMessageRequest>,
) -> Result<Json<MessageResponse>, StatusCode> {
    let msg_id = Uuid::new_v4();

    sqlx::query(
        "INSERT INTO messages (id, room_id, sender_id, content) VALUES ($1, $2, $3, $4)"
    )
    .bind(&msg_id)
    .bind(payload.room_id)
    .bind(payload.sender_id)
    .bind(&payload.content)
    .execute(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let message = sqlx::query_as::<_, Message>(
        "SELECT * FROM messages WHERE id = $1"
    )
    .bind(&msg_id)
    .fetch_one(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(MessageResponse {
        id: message.id,
        room_id: message.room_id,
        sender_id: message.sender_id,
        content: message.content,
        created_at: message.created_at,
    }))
}

pub async fn get_messages(
    State(state): State<AppState>,
    Query(params): Query<MessageQuery>,
) -> Result<Json<Vec<MessageResponse>>, StatusCode> {
    let messages = sqlx::query_as::<_, Message>(
        "SELECT * FROM messages WHERE room_id = $1 ORDER BY created_at ASC"
    )
    .bind(params.room_id)
    .fetch_all(&state.db)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let response = messages.into_iter().map(|m| MessageResponse {
        id: m.id,
        room_id: m.room_id,
        sender_id: m.sender_id,
        content: m.content,
        created_at: m.created_at,
    }).collect();

    Ok(Json(response))
}

// ===== WebSocket =====
pub async fn websocket_handler(
    ws: axum::extract::ws::WebSocketUpgrade,
) -> impl axum::response::IntoResponse {
    ws.on_upgrade(handle_socket)
}

async fn handle_socket(mut socket: WebSocket) {
    while let Some(msg) = socket.recv().await {
        if let Ok(msg) = msg {
            let _ = socket.send(msg).await;
        }
    }
}
