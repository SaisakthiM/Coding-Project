mod routes;
mod database;
mod models;

use axum::Router;
use std::env;
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    
    // Initialize tracing
    tracing_subscriber::fmt::init();
    
    // Connect to database
    let state = database::connect_db().await;
    database::init_database(&state.db)
        .await
        .expect("Failed to initialize database");

    // CORS middleware - IMPORTANT: Add this!
    let cors = CorsLayer::permissive();

    // Build router
    let app = Router::new()
        .merge(routes::home())
        .merge(routes::user())
        .merge(routes::room())
        .merge(routes::message())
        .merge(routes::auth())
        .merge(routes::profile())
        .merge(routes::settings())
        .merge(routes::ws())
        .with_state(state)
        .layer(cors);  // Add CORS layer!

    let listener = tokio::net::TcpListener::bind("127.0.0.1:8000")
        .await
        .expect("Failed to bind to 8000");

    println!("✓ Server running on http://localhost:8000");
    axum::serve(listener, app).await.unwrap();
}
