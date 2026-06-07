use actix_web::{App, HttpResponse, HttpServer, web};


async fn healthcheck() -> HttpResponse {
    HttpResponse::Ok().finish()
}

pub async fn runner() -> HttpResponse {
    HttpServer::new(
        || {
            App::new()
                .route("/health_check",web::get().to(healthcheck))
        })
        .bind("127.0.0.1:8080")
        .run()
        .await
}
