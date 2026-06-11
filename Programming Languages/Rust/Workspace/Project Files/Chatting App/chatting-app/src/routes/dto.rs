use serde::{Serialize, Deserialize};
use uuid::Uuid;


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
}

#[derive(Deserialize)]
pub struct ChatRoomRequest {
    pub name: String
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
