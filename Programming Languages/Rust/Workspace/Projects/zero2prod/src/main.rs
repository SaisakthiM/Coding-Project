use std::{net::TcpListener, sync::Arc};
use sqlx::{Connection, PgConnection, PgPool};
use zero2prod::{configurations::{self, get_configuration}, runner};
use actix_web::{App, HttpResponse, HttpServer, dev::Server, web};
use zero2prod::startup::run;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let configuration = get_configuration().expect("cannot be parsed");
    let configuration = configurations::get_configuration().expect("Failed to read configuration");
    let connection_string = configuration.database.connection_setting();

    let mut connection = PgPool::connect(&connection_string).await.expect("Failed to connect");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;
    run(listener,connection)?.await
}

