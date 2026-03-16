terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///home/saisakthi/.docker/desktop/docker.sock"
}

resource "docker_network" "dev_network" {
  name = "dev_network"
}

# ─── Hospital Management (SQLite — no DB needed) ───────────────────────────────
module "hospital_management" {
  source        = "../../modules/docker_app"
  name          = "hospital-management"
  image         = "hospital_management:latest"
  internal_port = 8000
  external_port = 8003
  network       = docker_network.dev_network.name
}

# ─── Blog Website (SQLite — no DB needed) ──────────────────────────────────────
module "blog_website" {
  source        = "../../modules/docker_app"
  name          = "blog-website"
  image         = "blogsite:latest"
  internal_port = 8000
  external_port = 8004
  network       = docker_network.dev_network.name
}

# ─── Quiz App (frontend only) ──────────────────────────────────────────────────
module "quiz_app" {
  source        = "../../modules/docker_app"
  name          = "quiz-app"
  image         = "quiz_app:latest"
  internal_port = 5173
  external_port = 5173
  network       = docker_network.dev_network.name
}

# ─── Bank Manager ──────────────────────────────────────────────────────────────
resource "docker_container" "bank_postgres" {
  name    = "bank-postgres"
  image   = "postgres:16-alpine"
  restart = "always"

  env = [
    "POSTGRES_USER=bankmanagement",
    "POSTGRES_PASSWORD=bankmanagement@2008",
    "POSTGRES_DB=bank"
  ]

  ports {
    internal = 5432
    external = 5433
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U bankmanagement -d bank"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
}

module "bank_manager_backend" {
  source        = "../../modules/docker_app"
  name          = "bank-manager-backend"
  image         = "bankmanager-backend:latest"
  internal_port = 8080
  external_port = 8080
  network       = docker_network.dev_network.name
  env = [
    "SPRING_DATASOURCE_URL=jdbc:postgresql://bank-postgres:5432/bank",
    "SPRING_DATASOURCE_USERNAME=bankmanagement",
    "SPRING_DATASOURCE_PASSWORD=bankmanagement@2008"
  ]
}

module "bank_manager_frontend" {
  source        = "../../modules/docker_app"
  name          = "bank-manager-frontend"
  image         = "bankmanager-frontend:latest"
  internal_port = 3000
  external_port = 3000
  network       = docker_network.dev_network.name
  env = [
    "VITE_API_URL=http://localhost:8080"
  ]
}

# ─── Notes App ─────────────────────────────────────────────────────────────────
resource "docker_container" "notes_postgres" {
  name    = "notes-postgres"
  image   = "postgres:16"
  restart = "always"

  env = [
    "POSTGRES_DB=notes_app",
    "POSTGRES_USER=saisakthi",
    "POSTGRES_PASSWORD=sai2008"
  ]

  ports {
    internal = 5432
    external = 5434
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U saisakthi -d notes_app"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
}

module "notes_backend" {
  source        = "../../modules/docker_app"
  name          = "notes-backend"
  image         = "notesapp-backend:latest"
  internal_port = 8000
  external_port = 8001
  network       = docker_network.dev_network.name
  env = [
    "DATABASE_NAME=notes_app",
    "DATABASE_USER=saisakthi",
    "DATABASE_PASSWORD=sai2008",
    "DATABASE_HOST=notes-postgres"
  ]
}

module "notes_frontend" {
  source        = "../../modules/docker_app"
  name          = "notes-frontend"
  image         = "notesapp-frontend_dev:latest"
  internal_port = 5173
  external_port = 5174
  network       = docker_network.dev_network.name
}

# ─── Video Uploader (no DB needed) ─────────────────────────────────────────────
module "video_uploader_backend" {
  source        = "../../modules/docker_app"
  name          = "video-uploader-backend"
  image         = "main-backend:latest"
  internal_port = 8080
  external_port = 8006
  network       = docker_network.dev_network.name
}

module "video_uploader_frontend" {
  source        = "../../modules/docker_app"
  name          = "video-uploader-frontend"
  image         = "main-frontend:latest"
  internal_port = 5173
  external_port = 5176
  network       = docker_network.dev_network.name
  env = [
    "VITE_API_URL=http://localhost:8006"
  ]
}

# ─── Nginx reverse proxy ───────────────────────────────────────────────────────
module "nginx" {
  source        = "../../modules/docker_app"
  name          = "nginx"
  image         = "nginx:latest"
  internal_port = 80
  external_port = 80
  network       = docker_network.dev_network.name

  volumes = [
    {
      host_path      = abspath("${path.module}/nginx.conf")
      container_path = "/etc/nginx/conf.d/default.conf"
      read_only      = true
    }
  ]
}
