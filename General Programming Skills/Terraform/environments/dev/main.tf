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


# -----------------------------
# Docker Network
# -----------------------------

resource "docker_network" "dev_network" {
  name = "dev_network"
}

# -----------------------------
# Platform Gateway (NGINX)
# -----------------------------

module "gateway" {
  source = "../../modules/docker_app"

  name          = "platform-gateway"
  image         = "platform-gateway:latest"

  internal_port = 80
  external_port = 80

  network       = docker_network.dev_network.name
}

# -----------------------------
# Notes Backend
# -----------------------------

module "notes_backend" {
  source        = "../../modules/docker_app"

  name          = "notes_backend"
  image         = "notesapp-backend:latest"

  internal_port = 8000
  external_port = 8001

  network       = docker_network.dev_network.name
}

# -----------------------------
# Hospital Management (Django)
# -----------------------------

module "hospital_management" {
  source        = "../../modules/docker_app"

  name          = "hospital_management"
  image         = "hospital_management:latest"

  internal_port = 8000
  external_port = 8003

  network       = docker_network.dev_network.name
}

# -----------------------------
# Blog Website
# -----------------------------

module "blogsite" {
  source        = "../../modules/docker_app"

  name          = "blogsite"
  image         = "blogsite:latest"

  internal_port = 8000
  external_port = 8004

  network       = docker_network.dev_network.name
}

# -----------------------------
# Time Clock
# -----------------------------

module "time_clock" {
  source        = "../../modules/docker_app"

  name          = "time-clock"
  image         = "time_clock:prod"

  internal_port = 80
  external_port = 8080

  network       = docker_network.dev_network.name
}