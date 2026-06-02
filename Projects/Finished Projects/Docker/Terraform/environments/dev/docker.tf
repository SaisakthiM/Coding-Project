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

locals {
  obs_path = "${path.module}/../../projects/platform/observability"
}

# ─── NETWORK ──────────────────────────────────────────────────
resource "docker_network" "gateway_net" {
  name = "gateway-net"
}

# ─── VOLUMES ──────────────────────────────────────────────────
resource "docker_volume" "notes_dist" { name = "gateway_notes-dist" }
resource "docker_volume" "bank_dist" { name = "gateway_bank-dist" }
resource "docker_volume" "quiz_dist" { name = "gateway_quiz-dist" }
resource "docker_volume" "video_dist" { name = "gateway_video-dist" }
resource "docker_volume" "api_dist" { name = "gateway_api-dist" }
resource "docker_volume" "notes_pgdata" { name = "gateway_notes-pgdata" }
resource "docker_volume" "notes_static" { name = "gateway_notes-static" }
resource "docker_volume" "notes_media" { name = "gateway_notes-media" }
resource "docker_volume" "bank_pgdata" { name = "gateway_bank-pgdata" }
resource "docker_volume" "doc_mysql" { name = "gateway_doc-mysql" }
resource "docker_volume" "doc_minio" { name = "gateway_doc-minio" }
resource "docker_volume" "doc_dist" { name = "gateway_doc-dist" }
resource "docker_volume" "blog_mysql" { name = "gateway_blog-mysql" }
resource "docker_volume" "blog_minio" { name = "gateway_blog-minio" }
resource "docker_volume" "intro_dist" { name = "gateway_intro-dist" }
resource "docker_volume" "record_dist" { name = "gateway_record-dist" }
resource "docker_volume" "jenkins_home" { name = "jenkins_home" }

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

resource "docker_image" "otel_gateway" {
  name         = "otel/opentelemetry-collector-contrib:0.100.0"
  keep_locally = true
}

resource "docker_image" "jenkins" {
  name         = "jenkins/jenkins:lts"
  keep_locally = true
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
    { volume_name = docker_volume.notes_dist.name, container_path = "/apps/notes", read_only = true },
    { volume_name = docker_volume.bank_dist.name, container_path = "/apps/bank", read_only = true },
    { volume_name = docker_volume.quiz_dist.name, container_path = "/apps/quiz", read_only = true },
    { volume_name = docker_volume.video_dist.name, container_path = "/apps/video", read_only = true },
    { volume_name = docker_volume.api_dist.name, container_path = "/apps/api-service", read_only = true },
    { volume_name = docker_volume.doc_dist.name, container_path = "/apps/document", read_only = true },
    { volume_name = docker_volume.intro_dist.name, container_path = "/apps/intro", read_only = true },
    { volume_name = docker_volume.record_dist.name, container_path = "/apps/record", read_only = true },
  ]
}

# ─── NGINX EXPORTER ───────────────────────────────────────────
module "nginx_exporter" {
  source        = "../../modules/docker_app"
  name          = "nginx-exporter"
  image         = "nginx/nginx-prometheus-exporter:latest"
  internal_port = 9113
  external_port = 9113
  network       = docker_network.gateway_net.name

  command = [
    "--nginx.scrape-uri=http://gateway:8080/nginx_status",
  ]

  depends_on = [module.gateway]
}

module "node_exporter" {
  source        = "../../modules/docker_app"
  name          = "node-exporter"
  image         = "prom/node-exporter:latest"
  internal_port = 9100
  external_port = 9100
  network       = docker_network.gateway_net.name

  volumes = [
    { host_path = "/proc", container_path = "/host/proc", read_only = true },
    { host_path = "/sys", container_path = "/host/sys", read_only = true },
    { host_path = "/", container_path = "/rootfs", read_only = true },
  ]

  command = [
    "--path.procfs=/host/proc",
    "--path.rootfs=/rootfs",
    "--path.sysfs=/host/sys",
    "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)",
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

# ─── INTRO PAGE AND RECORD PAGE ───────────────────────────────
resource "null_resource" "intro_page" {
  depends_on = [module.gateway]

  triggers = {
    file_sha   = filesha256("${path.module}/../../projects/intro/index.html")
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      docker pull alpine && \
      docker run --rm \
        -v gateway_intro-dist:/dest \
        -v "${abspath("${path.module}/../../projects/intro")}:/src:ro" \
        alpine sh -c "cp -r /src/. /dest/"
    EOT
  }
}

resource "null_resource" "record_page" {
  depends_on = [module.gateway]

  triggers = {
    file_sha   = filesha256("${path.module}/../../projects/security_tests/record.html")
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      docker pull alpine && \
      docker run --rm \
        -v gateway_record-dist:/dest \
        -v "${abspath("${path.module}/../../projects/security_tests")}:/src:ro" \
        alpine sh -c "cp -r /src/. /dest/"
    EOT
  }
}

# ─── JENKINS ──────────────────────────────────────────────────
resource "docker_container" "jenkins" {
  name    = "jenkins"
  image   = docker_image.jenkins.image_id
  restart = "unless-stopped"

  env = [
    "JENKINS_OPTS=--prefix=/jenkins",
    "JAVA_OPTS=-Djava.awt.headless=true -Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true"
    ]



  ports {
    internal = 8080
    external = 8090
  }
  ports {
    internal = 50000
    external = 50000
  }

  volumes {
    volume_name    = docker_volume.jenkins_home.name
    container_path = "/var/jenkins_home"
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  networks_advanced {
    name = docker_network.gateway_net.name
  }
}

# ─── OTEL GATEWAY (Docker-side collector) ─────────────────────
resource "docker_container" "otel_gateway" {
  name    = "otel-gateway"
  image   = docker_image.otel_gateway.image_id
  restart = "unless-stopped"

  ports {
    internal = 4317
    external = 4317
  }
  ports {
    internal = 4318
    external = 4318
  }
  ports {
    internal = 13133
    external = 13133
  }

  mounts {
    type      = "bind"
    source    = abspath("${local.obs_path}/otel-gateway-config.yml")
    target    = "/etc/otelcol-contrib/config.yaml"
    read_only = true
  }

  command = ["--config=/etc/otelcol-contrib/config.yaml"]

  networks_advanced {
    name = docker_network.gateway_net.name
  }
  networks_advanced {
    name = "kind"
  }

  healthcheck {
    test         = ["CMD", "wget", "--spider", "-q", "http://localhost:13133/"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }

  # otel_nodeport is defined in observability.tf
  depends_on = [kubectl_manifest.otel_nodeport]
}

# ── Jenkins Agent Image ───────────────────────────────────────
resource "docker_image" "jenkins_agent" {
  name         = "jenkins/inbound-agent:latest"
  keep_locally = true
}

# ── Jenkins Agent Container ───────────────────────────────────
resource "docker_container" "jenkins_agent" {
  name  = "jenkins-agent"
  image = docker_image.jenkins_agent.image_id
  restart = "unless-stopped"

  env = [
    "JENKINS_URL=http://jenkins:8080/jenkins/",
    "JENKINS_AGENT_NAME=Worker",
    "JENKINS_SECRET=af8a382676b767a8d8a33aaf1824256892d08a8f1fb6ff98ec0070fbbf689c66",
    "JENKINS_AGENT_WORKDIR=/home/jenkins/agent",
  ]

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  volumes {
  host_path      = "/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/environments/dev/terraform.tfvars"
  container_path = "/etc/terraform/terraform.tfvars"
}

  networks_advanced {
    name = docker_network.gateway_net.name
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 5
      docker exec --user root jenkins-agent bash -c "
        apt-get update -qq &&
        apt-get install -y docker.io wget unzip &&
        chmod 666 /var/run/docker.sock &&
        wget -q https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip &&
        unzip terraform_1.9.0_linux_amd64.zip &&
        mv terraform /usr/local/bin/ &&
        rm terraform_1.9.0_linux_amd64.zip &&
        chown -R jenkins:jenkins /home/jenkins &&
        echo 'Done!'
      "
    EOT
  }

  depends_on = [docker_container.jenkins]
}