use actix_web::{App, HttpResponse, HttpServer, dev::Server, web::{self}};
use sqlx::{PgConnection, PgPool};
use std::{net::TcpListener, rc::Rc, sync::Arc};

use crate::routes::{healthcheck, subscribe};

pub mod configurations;
pub mod routes;
pub mod startup;


pub fn runner(listener: TcpListener, pgconnection: PgPool) -> Result<Server,std::io::Error> {
    let pgconnection = web::Data::new(pgconnection);
    let server = HttpServer::new(move || {
    App::new()
    .route("/health_check", web::get().to(healthcheck))
    .route("/subscription", web::post().to(subscribe))
    .app_data(pgconnection.clone())
    })
    
    .listen(listener)?
    .run();
    Ok(server)
}
