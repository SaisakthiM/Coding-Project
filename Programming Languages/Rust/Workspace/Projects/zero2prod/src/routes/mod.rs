use actix_web::{App, HttpResponse, HttpServer, dev::Server, web::{self}};
use sqlx::PgPool;
use uuid::Uuid;
use chrono::Utc;
use std::net::TcpListener;

pub async fn healthcheck() -> HttpResponse {
    HttpResponse::Ok().finish()
}

#[derive(serde::Deserialize)]
pub struct Formdata {
    name: String,
    email:String
}

pub async fn subscribe(form: web::Form<Formdata>, connection: web::Data<PgPool>) -> HttpResponse {
    let id = Uuid::new_v4();
    let result = sqlx::query!(
        r#"INSERT INTO subscriptions (id,email,name,subscribed_at) VALUES ($1, $2, $3, $4)"#,
        id,
        form.email,
        form.name,
        Utc::now()
    )
    .execute(connection.get_ref())
    .await;

    match result {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(e) => {
            eprintln!("DB error: {:?}", e);  // ← add this
            HttpResponse::InternalServerError().finish()
        }
    }
}
