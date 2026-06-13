use chrono::{Utc,NaiveDateTime};
use serde::{Serialize, Deserialize};
use uuid::Uuid;
use sqlx::FromRow;

#[derive(Deserialize)]
pub struct CreateMessageRequest {
    pub room_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
}

#[derive(Serialize)]
pub struct MessageResponse {
    pub id: Uuid,
}

#[derive(Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub password: String
}

#[derive(Deserialize)]
pub struct ChatRoomRequest {
    pub name: String,
    pub creator_id: Uuid,  
}

#[derive(Deserialize)]
pub struct JoinRoomRequest {
    pub room_id: Uuid,
    pub user_id: Uuid,
}


#[derive(Deserialize)]
pub struct MessageRequest {
    pub room_id: Uuid,
    pub user_id: Uuid
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
}

#[derive(Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

#[derive(Serialize)]
pub struct AuthResponse {
    pub id: Uuid,
    pub token: String,
}

#[derive(Deserialize)]
pub struct WsParams {
    pub token: String,
}

#[derive(Serialize, FromRow, Debug)]
pub struct MessageRow {
    id: Uuid,
    room_id: Uuid,
    sender_id: Uuid,
    content: String,
    #[sqlx(rename = "created_at")]
    pub created_at: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow)]
pub struct RoomRow {
    pub id: Uuid,
    pub name: String,
    pub created_at: chrono::DateTime<Utc>,
}

#[derive(Serialize, Deserialize, FromRow)]
pub struct MemberRow {
    pub user_id: Uuid,
    pub username: String,
    pub last_seen_at: chrono::DateTime<Utc>,
}

#[derive(Serialize, Deserialize)]
pub struct UserIdQuery {
    pub user_id: Uuid,
}

#[derive(Serialize, Deserialize)]
pub struct ModifyName {
    pub new_name: String,  // user_id comes from Path, not here
}

#[derive(Serialize, Deserialize, FromRow)]
pub struct UserRow {
    pub id: Uuid,
    pub username: String,
    pub created_at: chrono::DateTime<Utc>,
}

#[derive(Debug, Deserialize)]
pub struct GetRoomsParams {
    pub user_id: Uuid,
}