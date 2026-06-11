use crate::{database::AppState, routes::dto};
use axum::{Json, Router, extract::State, http::StatusCode, routing::{get, post}};
use uuid::Uuid;
use chrono::Utc;

pub async fn hello_world() -> &'static str {
    "Hello world!"
}

pub async fn message() -> &'static str {
    "message received"
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
) -> Result<Json<dto::MessageResponse>, StatusCode> {
    let id = Uuid::new_v4();
    let timestamp = Utc::now();

    let result = sqlx::query(
        r#"
        INSERT INTO users (
            id,
            username,
            created_at
        )
        VALUES ($1, $2, $3)
        "#
    )
    .bind(id)
    .bind(&request.username)
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
    Json(request): Json<dto::MessageRequest>,
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
    .execute(&state.db)
    .await;

    println!("{:?}", result);

    result.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(StatusCode::CREATED)
}