terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "dev_network" {
  name = "dev_network"
}
module "notes_backend" {
  source        = "../../modules/docker_app"
  name          = "notes-backend"
  image         = "notes_app-backend:latest"
  internal_port = 8000
  external_port = 8001
  network       = docker_network.dev_network.name
}

module "quiz_app" {
  source        = "../../modules/docker_app"
  name          = "quiz-app"
  image         = "quiz-app:dev"
  internal_port = 5173
  external_port = 5173
  network       = docker_network.dev_network.name
}

module "time_clock" {
  source        = "../../modules/docker_app"
  name          = "time-clock"
  image         = "time_clock:prod"
  internal_port = 80
  external_port = 8080
  network       = docker_network.dev_network.name

}
module "nginx" {
  source = "../../modules/docker_app"

  name = "nginx"
  image = "nginx:latest"
  internal_port = 80
  external_port = 80
  network = docker_network.dev_network.name

  volumes = [
    {
      host_path = abspath("${path.module}/nginx.conf")
      container_path = "/etc/nginx/conf.d/default.conf"
      read_only = true
    }
  ]
}

module "hospital_management" {
  source = "../../modules/docker_app"
  name = "hospital_management"
  image = "hospital_management:dev"
  internal_port = 8000
  external_port = 8003
  network = docker_network.dev_network.name
}
module "notes_frontend" {
  source        = "../../modules/docker_app"
  name          = "notes_frontend"
  image         = "notes_app-frontend_dev"

  internal_port = 5173
  external_port = 5174
  network       = docker_network.dev_network.name
  
}



