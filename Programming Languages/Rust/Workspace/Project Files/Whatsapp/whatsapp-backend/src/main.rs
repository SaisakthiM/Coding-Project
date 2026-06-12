pub mod routes;
pub mod database;
use std::env;
pub mod configurations;

use axum::Router;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let state = database::connect_db().await;
    database::init_database(&state.db)
    .await
    .expect("Failed to initialize database");

    let app = Router::new()
        .merge(routes::home())
        .merge(routes::message())
        .merge(routes::user())
        .merge(routes::room())
        .merge(routes::joinRoom())
        .merge(routes::getMessage())
        .merge(routes::login())
        .merge(routes::ws())
        .merge(routes::room_routes())
        .with_state(state)
        ;
    println!("DATABASE_URL = {:?}", env::var("DATABASE_URL"));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();

    println!("Server running on http://localhost:3000");

    axum::serve(listener, app).await.unwrap();
}