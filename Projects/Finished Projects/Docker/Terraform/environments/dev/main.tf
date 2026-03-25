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
resource "docker_volume" "notes_dist"   { name = "gateway_notes-dist" }
resource "docker_volume" "bank_dist"    { name = "gateway_bank-dist" }
resource "docker_volume" "quiz_dist"    { name = "gateway_quiz-dist" }
resource "docker_volume" "video_dist"   { name = "gateway_video-dist" }
resource "docker_volume" "notes_pgdata" { name = "gateway_notes-pgdata" }
resource "docker_volume" "notes_static" { name = "gateway_notes-static" }
resource "docker_volume" "notes_media"  { name = "gateway_notes-media" }
resource "docker_volume" "bank_pgdata"  { name = "gateway_bank-pgdata" }

# ─── DOCKER IMAGES ────────────────────────────────────────────
resource "docker_image" "bank_backend" {
  name         = "bankmanager-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Bank Manager/backend/bank_management")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "bank_frontend_build" {
  name         = "bank-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Bank Manager/frontend")
    dockerfile = "Dockerfile.prod"
  }
}

resource "docker_image" "blog_website" {
  name         = "blogsite:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Blog Website")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "hospital_management" {
  name         = "hospital_management:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/hospital_management")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "quiz_frontend_build" {
  name         = "quiz-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Quiz App/quiz-app")
    dockerfile = "Dockerfile.prod"
  }
}

resource "docker_image" "video_backend" {
  name         = "video-uploader-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Video Uploader/Main/backend")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "video_frontend_build" {
  name         = "video-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Video Uploader/Main/frontend/video-uploader")
    dockerfile = "Dockerfile.prod"
  }
}

resource "docker_image" "notes_frontend_build" {
  name         = "notes-frontend-build:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Notes App/frontend/notes_app_frontend")
    dockerfile = "Dockerfile.prod"
  }
}

resource "docker_image" "notes_backend" {
  name         = "notesapp-backend:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Notes App/backend")
    dockerfile = "Dockerfile"
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
    { volume_name = docker_volume.notes_dist.name, container_path = "/apps/notes", read_only = true },
    { volume_name = docker_volume.bank_dist.name,  container_path = "/apps/bank",  read_only = true },
    { volume_name = docker_volume.quiz_dist.name,  container_path = "/apps/quiz",  read_only = true },
    { volume_name = docker_volume.video_dist.name, container_path = "/apps/video", read_only = true }
  ]
}

# ─── NOTES APP ────────────────────────────────────────────────
resource "docker_container" "notes_postgres" {
  name    = "notes-postgres"
  image   = "postgres:16"
  restart = "always"
  env = [
    "POSTGRES_DB=notes_app",
    "POSTGRES_USER=saisakthi",
    "POSTGRES_PASSWORD=sai2008"
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
    "DATABASE_NAME=notes_app",
    "DATABASE_USER=saisakthi",
    "DATABASE_PASSWORD=sai2008",
    "DATABASE_HOST=notes-postgres"
  ]
}

resource "docker_container" "notes_frontend_build" {
  name  = "notes-frontend-build"
  image = docker_image.notes_frontend_build.name
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.notes_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── BANK APP ─────────────────────────────────────────────────
resource "docker_container" "bank_postgres" {
  name    = "bank-postgres"
  image   = "postgres:16-alpine"
  restart = "always"
  env = [
    "POSTGRES_USER=bankmanagement",
    "POSTGRES_PASSWORD=bankmanagement@2008",
    "POSTGRES_DB=bank"
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
    "SPRING_DATASOURCE_URL=jdbc:postgresql://bank-postgres:5432/bank",
    "SPRING_DATASOURCE_USERNAME=bankmanagement",
    "SPRING_DATASOURCE_PASSWORD=bankmanagement@2008"
  ]
}

resource "docker_container" "bank_frontend_build" {
  name  = "bank-frontend-build"
  image = docker_image.bank_frontend_build.name
  networks_advanced { name = docker_network.gateway_net.name }
  mounts {
    source = docker_volume.bank_dist.name
    target = "/dist"
    type   = "volume"
  }
}

# ─── QUIZ ─────────────────────────────────────────────────────
resource "docker_container" "quiz_frontend_build" {
  name  = "quiz-frontend-build"
  image = docker_image.quiz_frontend_build.name
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
  name  = "video-frontend-build"
  image = docker_image.video_frontend_build.name
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
module "blog_website" {
  source        = "../../modules/docker_app"
  name          = "blog-website"
  image         = docker_image.blog_website.name
  internal_port = 8000
  external_port = 0
  network       = docker_network.gateway_net.name
}

# ═══════════════════════════════════════════════════════════════
# SOCIAL MEDIA APP — Kubernetes / kind
# ═══════════════════════════════════════════════════════════════

locals {
  social_base = abspath("${path.module}/../../projects/Social Media App")
}

# ─── BUILD SOCIAL MEDIA IMAGES ────────────────────────────────
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

# ─── KIND CLUSTER (null_resource — Terraform can't manage kind natively) ───
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

# ─── LOAD IMAGES INTO KIND (null_resource — kind load has no provider) ─────
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

# ─── CONNECT GATEWAY TO KIND NETWORK (null_resource — docker network has no provider) ───
resource "null_resource" "gateway_kind_network" {
  depends_on = [
    null_resource.kind_cluster,
    module.gateway,
  ]

  triggers = {
    cluster_id = null_resource.kind_cluster.id
  }

  provisioner "local-exec" {
    command = "docker network connect kind gateway || true"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "docker network disconnect kind gateway || true"
  }
}

# ─── INGRESS-NGINX (helm — clean lifecycle, upgradeable) ──────
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

# ─── KUBERNETES RESOURCES (kubectl_manifest — tracked in tf state) ──────────

resource "kubectl_manifest" "postgres_secret" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Secret
    metadata:
      name: postgres-secret
    type: Opaque
    data:
      POSTGRES_PASSWORD: cGFzc3dvcmQ=
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
                  value: socialdb
                - name: POSTGRES_USER
                  value: admin
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
  depends_on = [
    null_resource.kind_load_images,
    kubectl_manifest.postgres_statefulset,
  ]
  yaml_body = <<-YAML
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
                  value: socialdb
                - name: DB_USER
                  value: admin
                - name: DB_PASSWORD
                  value: password
                - name: DB_HOST
                  value: postgres
                - name: DB_PORT
                  value: "5432"
                - name: DEBUG
                  value: "True"
                - name: RUNNING_IN_DOCKER
                  value: "True"
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
