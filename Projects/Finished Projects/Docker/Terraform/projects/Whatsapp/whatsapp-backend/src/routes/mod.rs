mod handlers;
mod utils;

use axum::{
    routing::{get, post, put},
    Router,
};
use crate::database::AppState;

pub fn home() -> Router<AppState> {
    Router::new().route("/health", get(handlers::health))
}

pub fn user() -> Router<AppState> {
    Router::new()
        .route("/users", post(handlers::create_user))
        .route("/users/:user_id", get(handlers::get_user))
}

pub fn auth() -> Router<AppState> {
    Router::new().route("/login", post(handlers::login))
}

pub fn profile() -> Router<AppState> {
    Router::new()
        .route("/profile/:user_id", get(handlers::get_profile))
        .route("/profile/:user_id", put(handlers::update_profile))
}

pub fn settings() -> Router<AppState> {
    Router::new()
        .route("/settings/:user_id", get(handlers::get_settings))
        .route("/settings/:user_id", put(handlers::update_settings))
}

pub fn room() -> Router<AppState> {
    Router::new()
        .route("/room", post(handlers::create_room))
        .route("/room/join", post(handlers::join_room))
}

pub fn message() -> Router<AppState> {
    Router::new()
        .route("/message", post(handlers::send_message))
        .route("/message", get(handlers::get_messages))
}

pub fn ws() -> Router<AppState> {
    Router::new()
        .route("/rooms", get(handlers::get_user_rooms))
        .route("/room/:room_id/members", get(handlers::get_room_members))
        .route("/ws/:room_id", axum::routing::any(handlers::websocket_handler))
}

pub use utils::*;
