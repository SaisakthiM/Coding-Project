use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

// ===== Requests =====
#[derive(Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub password: String,
}

#[derive(Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

#[derive(Deserialize)]
pub struct UpdateProfileRequest {
    pub username: Option<String>,
    pub bio: Option<String>,
}

#[derive(Deserialize)]
pub struct UpdateSettingsRequest {
    pub theme: Option<String>,
    pub language: Option<String>,
    pub notifications: Option<bool>,
}

#[derive(Deserialize)]
pub struct CreateRoomRequest {
    pub name: String,
}

#[derive(Deserialize)]
pub struct JoinRoomRequest {
    pub room_id: Uuid,
    pub user_id: Uuid,
}

#[derive(Deserialize)]
pub struct SendMessageRequest {
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
}

#[derive(Deserialize)]
pub struct MessageQuery {
    pub room_id: Uuid,
    pub user_id: Uuid,
}

#[derive(Deserialize)]
pub struct UserIdQuery {
    pub user_id: Uuid,
}

// ===== Database Models =====
#[derive(Serialize, Deserialize, FromRow, Clone)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub password_hash: String,
    pub bio: Option<String>,
    pub avatar_url: Option<String>,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow, Clone)]
pub struct ChatRoom {
    pub id: Uuid,
    pub name: String,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow, Clone)]
pub struct Message {
    pub id: Uuid,
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow, Clone)]
pub struct RoomMember {
    pub id: Uuid,
    pub room_id: Uuid,
    pub user_id: Uuid,
    pub joined_at: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow, Clone)]
pub struct UserSettings {
    pub user_id: Uuid,
    pub theme: String,
    pub language: String,
    pub notifications: bool,
    pub created_at: NaiveDateTime,
    pub updated_at: NaiveDateTime,
}

// ===== Response Models =====
#[derive(Serialize)]
pub struct AuthResponse {
    pub id: Uuid,
    pub username: String,
    pub token: String,
}

#[derive(Serialize)]
pub struct UserResponse {
    pub id: Uuid,
    pub username: String,
    pub bio: Option<String>,
    pub avatar_url: Option<String>,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize)]
pub struct RoomResponse {
    pub id: Uuid,
    pub name: String,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize)]
pub struct MessageResponse {
    pub id: Uuid,
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
    pub created_at: NaiveDateTime,
}

#[derive(Serialize)]
pub struct MemberResponse {
    pub user_id: Uuid,
    pub username: String,
    pub avatar_url: Option<String>,
    pub joined_at: NaiveDateTime,
}

#[derive(Serialize)]
pub struct SettingsResponse {
    pub theme: String,
    pub language: String,
    pub notifications: bool,
}

#[derive(Serialize)]
pub struct ErrorResponse {
    pub error: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
}
