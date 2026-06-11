use actix_web::{App, HttpResponse, HttpServer, web};
use reqwest;
use sqlx::{Connection, Error::Database, PgPool, Row};
use zero2prod::configurations::{self, DatabaseSettings};
use std::{net::TcpListener, sync::Arc};

#[actix_web::test]
async fn health_check_works() {
    // Arrange
    let address = spawn_app().await;
    let client = reqwest::Client::new();
    // Act
    let response = client
    // Use the returned application address
    .get(&format!("{}/health_check", &address))
    .send()
    .await
    .expect("Failed to execute request.");
    // Assert
    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length());

}

// tests/test.rs
async fn spawn_app() -> String {
    let listener = TcpListener::bind("127.0.0.1:0")
    .expect("Failed to bind random port");
    // We retrieve the port assigned to us by the OS
    let configuration = configurations::get_configuration_test().expect("Failed to read configuration");
    let connection_string = configuration.database.connection_setting();
    let mut connection = PgPool::connect(&connection_string).await.expect("Failed to connect");  
    sqlx::query!("TRUNCATE TABLE subscriptions RESTART IDENTITY CASCADE")
        .execute(&connection)
        .await
        .expect("Failed to truncate subscriptions");
    let port = listener.local_addr().unwrap().port();
    let server = zero2prod::runner(listener,connection).expect("Failed to bind address");
    let _ = tokio::spawn(server);
    // We return the application address to the caller!
    format!("http://127.0.0.1:{}", port) 
}


#[actix_web::test]

async fn test_if_valid_form_return_200() {
    let app_address = spawn_app().await;
    

    let configuration = configurations::get_configuration_test().expect("Failed to read configuration");
    let connection_string = configuration.database.connection_setting();

    let mut connection = PgPool::connect(&connection_string).await.expect("Failed to connect");
    let client = reqwest::Client::new();


    let body = "name=le%20guin&email=urusula_le_guin%40gmail.com";
    let response = client
    .post(&format!("{}/subscription", &app_address))
    .header("Content-Type", "application/x-www-form-urlencoded")
    .body(body)
    .send()
    .await
    .expect("Failed to execute");

    assert_eq!(200,response.status().as_u16());

    let saved = sqlx::query!("SELECT email,name FROM subscriptions;").fetch_one(&connection).await.expect("Connection Failed");
    assert_eq!("le guin", saved.name);
    assert_eq!("urusula_le_guin@gmail.com", saved.email);
}

#[actix_web::test]
async fn test_if_data_missing_return_400() {
    let app_address = spawn_app().await;
    let client = reqwest::Client::new();

    let body = "name=le%20guin";
    let response = client
    .post(&format!("{}/subscription", &app_address))
    .header("Content-Type", "application/x-www-form-urlencoded")
    .body(body)
    .send()
    .await
    .expect("Failed to execute");
    assert_eq!(400,response.status().as_u16());
}

#[actix_web::test]
async fn test_if_wrong_method_return_405() {
    let app_address = spawn_app().await;
    let client = reqwest::Client::new();

    let response = client
    .get(&format!("{}/subscription", &app_address))
    .header("Content-Type", "application/x-www-form-urlencoded")
    .send()
    .await
    .expect("Failed to execute");
    assert_eq!(404,response.status().as_u16());
}


#[actix_web::test]
async fn test_if_wrong_header_return_400() {
    let app_address = spawn_app().await;
    let client = reqwest::Client::new();
    let body = "name=le%20guin";

    let response = client
    .post(&format!("{}/subscription", &app_address))
    .header("Content-Type", "application/json")
    .body(body)
    .send()
    .await
    .expect("Failed to execute");
    assert_eq!(415,response.status().as_u16());
}

