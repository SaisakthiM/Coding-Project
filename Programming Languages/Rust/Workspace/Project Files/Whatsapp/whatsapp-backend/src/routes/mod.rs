use crate::database::AppState;
use axum::{Json, Router, extract::{State, ws::{WebSocket, WebSocketUpgrade}}, http::StatusCode, response::{IntoResponse, Response}, routing::{any, delete, get, post, put}
};
use serde::de::IgnoredAny;
use uuid::Uuid;
use chrono::Utc;
pub mod handlers;
pub mod classes;
pub mod dto;

pub fn home() -> Router<AppState> {
    Router::new()
        .route("/", get(handlers::chat_home))
}

pub fn message() -> Router<AppState> {
    Router::new()
        .route("/message", post(handlers::create_message))
}

pub fn user() -> Router<AppState> {
    Router::new()
        .route("/users", post(handlers::create_user))
        .route("/users/{user_id}", get(handlers::get_user)
            .delete(handlers::delete_user)
            .put(handlers::modify_user))
}

pub fn room() -> Router<AppState> {
    Router::new().route("/room", post(handlers::create_room))
}

pub fn joinRoom() -> Router<AppState> {
    Router::new().route("/room/join", post(handlers::join_room))
}

pub fn getMessage() -> Router<AppState> {
    Router::new().route("/message", get(handlers::get_message))
}

pub fn login() -> Router<AppState> {
    Router::new()
        .route("/login", post(handlers::login))
}

pub fn ws() -> Router<AppState> {
    Router::new().route("/ws/{room_id}", any(handlers::handler))
}

pub fn room_routes() -> Router<AppState> {
    Router::new()
        .route("/rooms", get(handlers::get_user_rooms))
        .route("/room/{room_id}/members", get(handlers::get_room_members))
}

