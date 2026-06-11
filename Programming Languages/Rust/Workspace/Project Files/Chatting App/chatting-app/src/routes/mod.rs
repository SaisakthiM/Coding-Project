use crate::database::AppState;
use axum::{Json, Router, extract::State, http::StatusCode, routing::{get, post}};
use serde::de::IgnoredAny;
use uuid::Uuid;
use chrono::Utc;
pub mod handlers;
pub mod classes;
pub mod dto;

pub fn home() -> Router<AppState> {
    Router::new()
        .route("/", get(handlers::hello_world))
}

pub fn message() -> Router<AppState> {
    Router::new()
        .route("/message", post(handlers::create_message))
}

pub fn user() -> Router<AppState> {
    Router::new()
        .route("/users", post(handlers::create_user))
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