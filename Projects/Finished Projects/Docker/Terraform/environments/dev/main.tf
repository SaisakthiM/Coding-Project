terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  host = "unix:///home/saisakthi/.docker/desktop/docker.sock"
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "kind-social-media"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-social-media"
  }
}

# ─── NETWORK ──────────────────────────────────────────────────
resource "docker_network" "gateway_net" {
  name = "gateway-net"
}

# ─── VOLUMES ──────────────────────────────────────────────────
resource "docker_volume" "notes_dist"    { name = "gateway_notes-dist" }
resource "docker_volume" "bank_dist"     { name = "gateway_bank-dist" }
resource "docker_volume" "quiz_dist"     { name = "gateway_quiz-dist" }
resource "docker_volume" "video_dist"    { name = "gateway_video-dist" }
resource "docker_volume" "api_dist"      { name = "gateway_api-dist" }
resource "docker_volume" "notes_pgdata"  { name = "gateway_notes-pgdata" }
resource "docker_volume" "notes_static"  { name = "gateway_notes-static" }
resource "docker_volume" "notes_media"   { name = "gateway_notes-media" }
resource "docker_volume" "bank_pgdata"   { name = "gateway_bank-pgdata" }
resource "docker_volume" "doc_mysql"     { name = "gateway_doc-mysql" }
resource "docker_volume" "doc_minio"     { name = "gateway_doc-minio" }
resource "docker_volume" "doc_dist"      { name = "gateway_doc-dist" }
resource "docker_volume" "blog_mysql"    { name = "gateway_blog-mysql" }
resource "docker_volume" "blog_minio"    { name = "gateway_blog-minio" }
resource "docker_volume" "intro_dist"    { name = "gateway_intro-dist" }

# ─── DOCKER IMAGES ────────────────────────────────────────────
resource "docker_image" "bank_backend" {
  name         = "bankmanager-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Bank Manager/backend/bank_management")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Bank Manager/backend/bank_management", "**") :
      filesha256("${path.module}/../../projects/Bank Manager/backend/bank_management/${f}")
      if !can(regex("(\\.git|target|__pycache__|\\.pyc)", f))
    ]))
  }
}

resource "docker_image" "bank_frontend_build" {
  name         = "bank-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Bank Manager/frontend")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Bank Manager/frontend", "**") :
      filesha256("${path.module}/../../projects/Bank Manager/frontend/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

resource "docker_image" "blog_website" {
  name         = "blogsite:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Blog Website")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Blog Website", "**") :
      filesha256("${path.module}/../../projects/Blog Website/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc|staticfiles|media)", f))
    ]))
  }
}

resource "docker_image" "hospital_management" {
  name         = "hospital_management:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/hospital_management")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/hospital_management", "**") :
      filesha256("${path.module}/../../projects/hospital_management/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc|staticfiles|media)", f))
    ]))
  }
}

resource "docker_image" "quiz_frontend_build" {
  name         = "quiz-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Quiz App/quiz-app")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Quiz App/quiz-app", "**") :
      filesha256("${path.module}/../../projects/Quiz App/quiz-app/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

resource "docker_image" "video_backend" {
  name         = "video-uploader-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Video Uploader/Main/backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Video Uploader/Main/backend", "**") :
      filesha256("${path.module}/../../projects/Video Uploader/Main/backend/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc)", f))
    ]))
  }
}

resource "docker_image" "video_frontend_build" {
  name         = "video-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Video Uploader/Main/frontend/video-uploader")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Video Uploader/Main/frontend/video-uploader", "**") :
      filesha256("${path.module}/../../projects/Video Uploader/Main/frontend/video-uploader/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

resource "docker_image" "notes_frontend_build" {
  name         = "notes-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Notes App/frontend/notes_app_frontend")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Notes App/frontend/notes_app_frontend", "**") :
      filesha256("${path.module}/../../projects/Notes App/frontend/notes_app_frontend/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

resource "docker_image" "notes_backend" {
  name         = "notesapp-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Notes App/backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Notes App/backend", "**") :
      filesha256("${path.module}/../../projects/Notes App/backend/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc)", f))
    ]))
  }
}

resource "docker_image" "api_service_backend" {
  name         = "api-service-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/API Service/backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/API Service/backend", "**") :
      filesha256("${path.module}/../../projects/API Service/backend/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc)", f))
    ]))
  }
}

resource "docker_image" "api_service_frontend_build" {
  name         = "api-service-frontend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/API Service/frontend/api-service")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/API Service/frontend/api-service", "**") :
      filesha256("${path.module}/../../projects/API Service/frontend/api-service/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

resource "docker_image" "doc_backend" {
  name         = "documentintelligenceplatform-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Document Intelligence Platform/backend/document_backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Document Intelligence Platform/backend/document_backend", "**") :
      filesha256("${path.module}/../../projects/Document Intelligence Platform/backend/document_backend/${f}")
      if !can(regex("(\\.git|__pycache__|\\.pyc)", f))
    ]))
  }
}

resource "docker_image" "doc_frontend_build" {
  name         = "documentintelligenceplatform-frontend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Document Intelligence Platform/frontend/document_frontend")
    dockerfile = "Dockerfile.prod"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Document Intelligence Platform/frontend/document_frontend", "**") :
      filesha256("${path.module}/../../projects/Document Intelligence Platform/frontend/document_frontend/${f}")
      if !can(regex("(\\.git|node_modules|dist)", f))
    ]))
  }
}

# ─── GATEWAY ──────────────────────────────────────────────────
module "gateway" {
  source        = "../../modules/docker_app"
  name          = "gateway"
  image         = "nginx:alpine"
  internal_port = 80
  external_port = 80
  network       = docker_network.gateway_net.name

  volumes = [
    {
      host_path      = abspath("${path.module}/nginx/default.conf")
      container_path = "/etc/nginx/conf.d/default.conf"
      read_only      = true
    }
  ]

  named_volumes = [
    { volume_name = docker_volume.notes_dist.name, container_path = "/apps/notes",       read_only = true },
    { volume_name = docker_volume.bank_dist.name,  container_path = "/apps/bank",        read_only = true },
    { volume_name = docker_volume.quiz_dist.name,  container_path = "/apps/quiz",        read_only = true },
    { volume_name = docker_volume.video_dist.name, container_path = "/apps/video",       read_only = true },
    { volume_name = docker_volume.api_dist.name,   container_path = "/apps/api-service", read_only = true },
    { volume_name = docker_volume.doc_dist.name,   container_path = "/apps/document",    read_only = true },
    { volume_name = docker_volume.intro_dist.name, container_path = "/apps/intro",       read_only = true },
  ]
}

# ─── NOTES APP ────────────────────────────────────────────────
resource "docker_container" "notes_postgres" {
  name                  = "notes-postgres"
  image                 = "postgres:16"
  restart               = "always"
  destroy_grace_seconds = 30
  must_run              = true
  env = [
    "POSTGRES_DB=${var.notes_db_name}",
    "POSTGRES_USER=${var.notes_db_user}",
    "POSTGRES_PASSWORD=${var.notes_db_password}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.notes_pgdata.name
    target = "/var/lib/postgresql/data"
    type   = "volume"
  }
}

module "notes_backend" {
  source        = "../../modules/docker_app"
  name          = "notes-backend"
  image         = docker_image.notes_backend.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
  env = [
    "DATABASE_NAME=${var.notes_db_name}",
    "DATABASE_USER=${var.notes_db_user}",
    "DATABASE_PASSWORD=${var.notes_db_password}",
    "DATABASE_HOST=notes-postgres",
  ]
}

resource "docker_container" "notes_frontend_build" {
  name                  = "notes-frontend-build"
  image                 = docker_image.notes_frontend_build.name
  destroy_grace_seconds = 30
  must_run              = true
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.notes_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── BANK APP ─────────────────────────────────────────────────
resource "docker_container" "bank_postgres" {
  name                  = "bank-postgres"
  image                 = "postgres:16-alpine"
  destroy_grace_seconds = 30
  must_run              = true
  restart               = "always"
  env = [
    "POSTGRES_USER=${var.bank_db_user}",
    "POSTGRES_PASSWORD=${var.bank_db_password}",
    "POSTGRES_DB=${var.bank_db_name}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.bank_pgdata.name
    target = "/var/lib/postgresql/data"
    type   = "volume"
  }
}

module "bank_backend" {
  source        = "../../modules/docker_app"
  name          = "bank-backend"
  image         = docker_image.bank_backend.name
  internal_port = 8080
  external_port = 0
  network       = docker_network.gateway_net.name
  env = [
    "SPRING_DATASOURCE_URL=jdbc:postgresql://bank-postgres:5432/${var.bank_db_name}",
    "SPRING_DATASOURCE_USERNAME=${var.bank_db_user}",
    "SPRING_DATASOURCE_PASSWORD=${var.bank_db_password}",
    "DB_HOST=bank-postgres",
    "DB_PORT=5432",
    "DB_USER=${var.bank_db_user}",
  ]
}

resource "docker_container" "bank_frontend_build" {
  name                  = "bank-frontend-build"
  image                 = docker_image.bank_frontend_build.name
  destroy_grace_seconds = 30
  must_run              = true
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.bank_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── QUIZ ─────────────────────────────────────────────────────
resource "docker_container" "quiz_frontend_build" {
  name                  = "quiz-frontend-build"
  image                 = docker_image.quiz_frontend_build.name
  destroy_grace_seconds = 30
  must_run              = true
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.quiz_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── VIDEO ────────────────────────────────────────────────────
module "video_backend" {
  source        = "../../modules/docker_app"
  name          = "video-uploader-backend"
  image         = docker_image.video_backend.name
  internal_port = 8080
  external_port = 0
  network       = docker_network.gateway_net.name
  env           = ["UPLOADS_DIR=/app/Uploads"]
}

resource "docker_container" "video_frontend_build" {
  name                  = "video-frontend-build"
  image                 = docker_image.video_frontend_build.name
  destroy_grace_seconds = 30
  must_run              = true
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.video_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── HOSPITAL ─────────────────────────────────────────────────
module "hospital_management" {
  source        = "../../modules/docker_app"
  name          = "hospital-management"
  image         = docker_image.hospital_management.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
}

# ─── BLOG ─────────────────────────────────────────────────────
resource "docker_container" "blog_db" {
  name    = "blog-db"
  image   = "mysql:8.0"
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=${var.blog_db_password}",
    "MYSQL_DATABASE=${var.blog_db_name}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.blog_mysql.name
    target = "/var/lib/mysql"
    type   = "volume"
  }
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${var.blog_db_password}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
}

resource "docker_container" "blog_minio" {
  name    = "blog-minio"
  image   = "quay.io/minio/minio:latest"
  restart = "always"
  command = ["server", "/data", "--console-address", ":9091"]
  env = [
    "MINIO_ROOT_USER=${var.blog_minio_user}",
    "MINIO_ROOT_PASSWORD=${var.blog_minio_password}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.blog_minio.name
    target = "/data"
    type   = "volume"
  }
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "20s"
  }
}

resource "docker_container" "blog_minio_init" {
  name       = "blog-minio-init"
  image      = "quay.io/minio/mc:latest"
  must_run   = false
  restart    = "no"
  entrypoint = ["/bin/sh", "-c"]
  command = [
    <<-EOT
      until mc alias set blogminio http://blog-minio:9000 ${var.blog_minio_user} ${var.blog_minio_password}; do
        echo "Waiting for MinIO..."; sleep 2;
      done
      mc mb --ignore-existing blogminio/blog-media
      mc anonymous set download blogminio/blog-media
      echo "Bucket setup complete!"
    EOT
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  depends_on = [docker_container.blog_minio]
}

module "blog_website" {
  source        = "../../modules/docker_app"
  name          = "blog-website"
  image         = docker_image.blog_website.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
  depends_on    = [docker_container.blog_db, docker_container.blog_minio]
  env = [
    "DB_NAME=${var.blog_db_name}",
    "DB_USER=root",
    "DB_PASSWORD=${var.blog_db_password}",
    "DB_HOST=blog-db",
    "DB_PORT=3306",
    "MINIO_ACCESS_KEY=${var.blog_minio_user}",
    "MINIO_SECRET_KEY=${var.blog_minio_password}",
    "MINIO_BUCKET=blog-media",
    "MINIO_ENDPOINT=http://blog-minio:9000",
    "SECRET_KEY=${var.blog_secret_key}",
    "DEBUG=False",
    "ALLOWED_HOSTS=${var.blog_allowed_hosts}",
    "MINIO_PUBLIC_URL=http://localhost/blog/minio",
    "MYSQLCLIENT_LDFLAGS=`pkg-config mysqlclient --libs`",
    "MYSQLCLIENT_CFLAGS=`pkg-config mysqlclient --cflags`",
  ]
}

# ─── API SERVICE ──────────────────────────────────────────────
module "api_service_backend" {
  source        = "../../modules/docker_app"
  name          = "api-service-backend"
  image         = docker_image.api_service_backend.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
  env = [
    "API_KEY_WEATHER=${var.api_key_weather}",
  ]
}

resource "docker_container" "api_service_frontend_build" {
  name                  = "api-service-frontend-build"
  image                 = docker_image.api_service_frontend_build.name
  must_run              = false
  restart               = "no"
  destroy_grace_seconds = 30
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.api_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── DOCUMENT INTELLIGENCE PLATFORM ──────────────────────────
resource "docker_container" "doc_mysql" {
  name    = "doc-mysql"
  image   = "mysql:8.0"
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=${var.doc_db_password}",
    "MYSQL_DATABASE=${var.doc_db_name}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.doc_mysql.name
    target = "/var/lib/mysql"
    type   = "volume"
  }
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${var.doc_db_password}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
}

resource "docker_container" "doc_minio" {
  name                  = "doc-minio"
  image                 = "quay.io/minio/minio:latest"
  restart               = "always"
  destroy_grace_seconds = 30
  must_run              = true
  command               = ["server", "/data", "--console-address", ":9001"]
  env = [
    "MINIO_ROOT_USER=${var.doc_minio_user}",
    "MINIO_ROOT_PASSWORD=${var.doc_minio_password}",
  ]
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.doc_minio.name
    target = "/data"
    type   = "volume"
  }
}

module "doc_backend" {
  source        = "../../modules/docker_app"
  name          = "doc-backend"
  image         = docker_image.doc_backend.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
  env = [
    "DB_HOST=doc-mysql",
    "DB_PORT=3306",
    "DB_NAME=${var.doc_db_name}",
    "DB_USER=root",
    "DB_PASSWORD=${var.doc_db_password}",
    "MINIO_ENDPOINT=doc-minio:9000",
    "MINIO_ACCESS_KEY=${var.doc_minio_user}",
    "MINIO_SECRET_KEY=${var.doc_minio_password}",
    "MINIO_BUCKET=documents",
    "MINIO_SECURE=False",
    "GEMINI_API_KEY=${var.doc_gemini_api_key}",
    "OLLAMA_HOST=host.docker.internal",
    "PORT_AI=11434",
    "DJANGO_SECRET_KEY=${var.doc_django_secret_key}",
    "DEBUG=False",
    "ALLOWED_HOSTS=localhost,127.0.0.1,gateway,doc-backend",
  ]
}

resource "docker_container" "doc_frontend_build" {
  name                  = "doc-frontend-build"
  image                 = docker_image.doc_frontend_build.name
  must_run              = false
  restart               = "no"
  destroy_grace_seconds = 30
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.doc_dist.name
    target = "/output"
    type   = "volume"
  }
}

# ─── INTRO PAGE ───────────────────────────────────────────────
resource "null_resource" "intro_page" {
  depends_on = [module.gateway]
  triggers = {
    file_sha = filesha256("${path.module}/../../projects/intro/index.html")
  }
  provisioner "local-exec" {
    command = <<-EOT
      docker run --rm \
        -v ${docker_volume.intro_dist.name}:/dest \
        -v "${abspath("${path.module}/../../projects/intro")}:/src:ro" \
        alpine sh -c "cp /src/index.html /dest/index.html"
    EOT
  }
}

# ─── Other Projects ───────────────────────────────────────────────

# ═══════════════════════════════════════════════════════════════
# SOCIAL MEDIA APP — Kubernetes / kind
# ═══════════════════════════════════════════════════════════════

locals {
  social_base = abspath("${path.module}/../../projects/Social Media App")
}

resource "docker_image" "social_django" {
  name         = "socialmediaapp-django:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/backend", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/backend/${f}")
      if !can(regex("(__pycache__|.pyc|.git)", f))
    ]))
  }
}

resource "docker_image" "social_frontend" {
  name         = "socialmediaapp-frontend-prod:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/frontend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/frontend", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/frontend/${f}")
      if !can(regex("(node_modules|dist|.git)", f))
    ]))
  }
}

resource "docker_image" "social_go" {
  name         = "socialmediaapp-microservice-go:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/microservice-go")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/microservice-go", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/microservice-go/${f}")
      if !can(regex(".git", f))
    ]))
  }
}

resource "docker_image" "social_java" {
  name         = "socialmediaapp-microservice-java:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/microservice-java")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/microservice-java", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/microservice-java/${f}")
      if !can(regex("(target|.git)", f))
    ]))
  }
}

resource "docker_image" "social_minio" {
  name         = "socialmediaapp-minio:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/storage/minio")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/storage/minio", "**") :
      filesha256("${path.module}/../../projects/Social Media App/storage/minio/${f}")
      if !can(regex(".git", f))
    ]))
  }
}

resource "null_resource" "kind_cluster" {
  triggers = {
    kind_config = filesha256("${path.module}/../../projects/Social Media App/infrastructure/kind/kind-config.yaml")
  }
  provisioner "local-exec" {
    command = <<-EOT
      if ! kind get clusters | grep -q "social-media"; then
        kind create cluster --config "${abspath("${path.module}/../../projects/Social Media App/infrastructure/kind/kind-config.yaml")}"
      fi
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name social-media"
  }
}

resource "null_resource" "kind_load_images" {
  depends_on = [
    null_resource.kind_cluster,
    docker_image.social_django,
    docker_image.social_frontend,
    docker_image.social_go,
    docker_image.social_java,
    docker_image.social_minio,
  ]
  triggers = {
    django_id   = docker_image.social_django.image_id
    frontend_id = docker_image.social_frontend.image_id
    go_id       = docker_image.social_go.image_id
    java_id     = docker_image.social_java.image_id
    minio_id    = docker_image.social_minio.image_id
  }
  provisioner "local-exec" {
    command = <<-EOT
      kind load docker-image socialmediaapp-django:latest --name social-media
      kind load docker-image socialmediaapp-frontend-prod:latest --name social-media
      kind load docker-image socialmediaapp-microservice-go:latest --name social-media
      kind load docker-image socialmediaapp-microservice-java:latest --name social-media
      kind load docker-image socialmediaapp-minio:latest --name social-media
    EOT
  }
}

resource "null_resource" "gateway_kind_network" {
  depends_on = [null_resource.kind_cluster, module.gateway]
  triggers   = { cluster_id = null_resource.kind_cluster.id }
  provisioner "local-exec" {
    command = "docker network connect kind gateway || true"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "docker network disconnect kind gateway || true"
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on       = [null_resource.kind_cluster]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
  timeout          = 120
  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }
  set {
    name  = "controller.hostPort.ports.http"
    value = "80"
  }
  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }
}

resource "kubectl_manifest" "postgres_secret" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Secret
    metadata:
      name: postgres-secret
    type: Opaque
    data:
      POSTGRES_PASSWORD: ${base64encode(var.social_db_password)}
  YAML
}

resource "kubectl_manifest" "postgres_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: postgres
    spec:
      ports:
        - port: 5432
          targetPort: 5432
      selector:
        app: postgres
  YAML
}

resource "kubectl_manifest" "postgres_statefulset" {
  depends_on = [kubectl_manifest.postgres_secret, kubectl_manifest.postgres_service]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: postgres
    spec:
      serviceName: postgres
      replicas: 1
      selector:
        matchLabels:
          app: postgres
      template:
        metadata:
          labels:
            app: postgres
        spec:
          containers:
            - name: postgres
              image: postgres:15
              ports:
                - containerPort: 5432
              env:
                - name: POSTGRES_DB
                  value: ${var.social_db_name}
                - name: POSTGRES_USER
                  value: ${var.social_db_user}
                - name: POSTGRES_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: postgres-secret
                      key: POSTGRES_PASSWORD
              volumeMounts:
                - name: postgres-storage
                  mountPath: /var/lib/postgresql/data
      volumeClaimTemplates:
        - metadata:
            name: postgres-storage
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
  YAML
}

resource "kubectl_manifest" "backend_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: backend
    spec:
      selector:
        app: backend
      ports:
        - port: 8000
          targetPort: 8000
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "backend_deployment" {
  depends_on = [null_resource.kind_load_images, kubectl_manifest.postgres_statefulset]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: backend
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: backend
      template:
        metadata:
          labels:
            app: backend
        spec:
          containers:
            - name: backend
              image: socialmediaapp-django:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8000
              env:
                - name: DB_NAME
                  value: ${var.social_db_name}
                - name: DB_USER
                  value: ${var.social_db_user}
                - name: DB_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: postgres-secret
                      key: POSTGRES_PASSWORD
                - name: DB_HOST
                  value: postgres
                - name: DB_PORT
                  value: "5432"
                - name: DEBUG
                  value: "True"
                - name: RUNNING_IN_DOCKER
                  value: "True"
                - name: REDIS_PORT
                  value: "6379"
  YAML
}

resource "kubectl_manifest" "frontend_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: frontend-prod
    spec:
      selector:
        app: frontend
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "frontend_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: frontend-prod
      labels:
        app: frontend
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: frontend
      template:
        metadata:
          labels:
            app: frontend
        spec:
          containers:
            - name: frontend
              image: socialmediaapp-frontend-prod:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 80
  YAML
}

resource "kubectl_manifest" "microservice_go_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: microservice-go
    spec:
      selector:
        app: microservice-go
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "microservice_go_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: microservice-go
      labels:
        app: microservice-go
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: microservice-go
      template:
        metadata:
          labels:
            app: microservice-go
        spec:
          containers:
            - name: microservice-go
              image: socialmediaapp-microservice-go:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8080
              env:
                - name: REDIS_HOST
                  value: redis
                - name: REDIS_PORT
                  value: "6379"
  YAML
}

resource "kubectl_manifest" "microservice_java_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: microservice-java
    spec:
      selector:
        app: microservice-java
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "microservice_java_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: microservice-java
      labels:
        app: microservice-java
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: microservice-java
      template:
        metadata:
          labels:
            app: microservice-java
        spec:
          containers:
            - name: microservice-java
              image: socialmediaapp-microservice-java:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8080
              env:
                - name: SPRING_CASSANDRA_CONTACT-POINTS
                  value: cassandra
                - name: SPRING_CASSANDRA_PORT
                  value: "9042"
                - name: SPRING_CASSANDRA_LOCAL-DATACENTER
                  value: datacenter1
  YAML
}

resource "kubectl_manifest" "minio_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: minio
    spec:
      selector:
        app: minio
      ports:
        - name: api
          protocol: TCP
          port: 9000
          targetPort: 9000
        - name: console
          protocol: TCP
          port: 9004
          targetPort: 9004
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "minio_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: minio
      labels:
        app: minio
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: minio
      template:
        metadata:
          labels:
            app: minio
        spec:
          containers:
            - name: minio
              image: socialmediaapp-minio:latest
              imagePullPolicy: Never
              args:
                - server
                - /data
                - --console-address
                - ":9004"
              ports:
                - containerPort: 9000
                - containerPort: 9004
              env:
                - name: MINIO_ROOT_USER
                  value: ${var.social_minio_user}
                - name: MINIO_ROOT_PASSWORD
                  value: ${var.social_minio_password}
              volumeMounts:
                - name: minio-data
                  mountPath: /data
          volumes:
            - name: minio-data
              emptyDir:
                sizeLimit: 2Gi
  YAML
}

resource "kubectl_manifest" "ingress_api" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-api-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /api/$2
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /social/api(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: backend
                    port:
                      number: 8000
  YAML
}

resource "kubectl_manifest" "ingress_minio" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-minio-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$2
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /social/minio(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: minio
                    port:
                      number: 9000
  YAML
}

resource "kubectl_manifest" "ingress_frontend" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-frontend-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$2
        nginx.ingress.kubernetes.io/use-regex: "true"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /social(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: frontend-prod
                    port:
                      number: 80
  YAML
}

resource "kubectl_manifest" "redis_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: redis
      namespace: default
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: redis
      template:
        metadata:
          labels:
            app: redis
        spec:
          containers:
          - name: redis
            image: redis:7-alpine
            ports:
            - containerPort: 6379
            resources:
              requests:
                memory: "64Mi"
                cpu: "50m"
  YAML
}

resource "kubectl_manifest" "redis_service" {
  depends_on = [kubectl_manifest.redis_deployment]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: redis
      namespace: default
    spec:
      selector:
        app: redis
      ports:
      - port: 6379
        targetPort: 6379
  YAML
}

/*
# ─── CASSANDRA ────────────────────────────────────────────────
resource "helm_release" "cassandra" {
  depends_on = [null_resource.kind_cluster]
  name       = "cassandra"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "cassandra"
  namespace  = "default"
  wait       = true
  timeout    = 300
  
  set {
    name  = "replicaCount"
    value = "1"  # Keep it 1 for local dev, saves resources
  }
  set {
    name  = "resources.requests.memory"
    value = "512Mi"
  }
  set {
    name  = "resources.requests.cpu"
    value = "250m"
  }
}

# ─── REDIS ────────────────────────────────────────────────────
resource "helm_release" "redis" {
  depends_on = [null_resource.kind_cluster, helm_release.cassandra]
  name       = "redis"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  namespace  = "default"
  wait       = true
  timeout    = 120

  set {
    name  = "auth.password"
    value = "redis-password"
  }
  set {
    name  = "architecture"
    value = "standalone"  # Saves resources vs replication
  }
}

resource "helm_release" "kube_prometheus_stack" {
  depends_on = [null_resource.kind_cluster, helm_release.redis]
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  wait       = true
  timeout    = 600 # This chart can take a while to deploy

  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigs"
    value = file("${path.module}/../../projects/Social Media App/platform/observability/prometheus.yml")
    type  = "string"
  }
  set {
    name  = "grafana.adminPassword"
    value = "admin" # Consider using a Kubernetes secret for production
  }
  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }
  set {
    name  = "grafana.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
    value = "/"
  }
  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "false"
  }
  set {
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.local" # You might need to add this to your /etc/hosts
  }
}

resource "helm_release" "loki" {
  depends_on = [helm_release.kube_prometheus_stack]
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace  = "monitoring"
  create_namespace = true
  wait       = true
  timeout    = 300

  set {
    name  = "loki.config"
    value = file("${path.module}/../../projects/Social Media App/platform/observability/loki-config.yml")
    type  = "string"
  }
}

resource "helm_release" "tempo" {
  depends_on = [helm_release.loki, kubectl_manifest.minio_service]
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  namespace  = "monitoring"
  create_namespace = true
  wait       = true
  timeout    = 300

  set {
    name  = "tempo.config"
    value = file("${path.module}/../../projects/Social Media App/platform/observability/tempo-config.yml")
    type  = "string"
  }
}

resource "helm_release" "promtail" {
  depends_on = [helm_release.loki]
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = "monitoring"
  create_namespace = true
  wait       = true
  timeout    = 180

  set {
    name  = "config.snippets.scrapeConfigs"
    value = file("${path.module}/../../projects/Social Media App/platform/observability/promtail-config.yml")
    type  = "string"
  }
}
*/
