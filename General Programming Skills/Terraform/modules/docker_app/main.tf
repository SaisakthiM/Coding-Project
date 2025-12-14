terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_container" "app" {
  name  = var.name
  image = var.image
  restart = "always"

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name = var.network
  }

  # Mount host directories/files using the existing 'volumes' variable
  dynamic "mounts" {
    for_each = var.volumes
    content {
      source    = mounts.value.host_path
      target    = mounts.value.container_path
      type      = "bind"
      read_only = mounts.value.read_only
    }
  }
}


