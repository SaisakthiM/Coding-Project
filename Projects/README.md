# 🧩 Full-Stack Project Cluster

> A unified, production-style monorepo hosting **9 full-stack applications** behind a single Nginx API gateway — provisioned entirely with **Terraform**, deployed across **Docker** and **Kubernetes (kind)**.

<!-- PROJECT BANNER IMAGE -->
<!-- Replace the comment below with your banner screenshot -->
![alt text](image.png)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Projects](#-projects)
  - [Notes App](#1-notes-app)
  - [Bank Manager](#2-bank-manager)
  - [Quiz App](#3-quiz-app)
  - [Video Uploader](#4-video-uploader)
  - [Blog Website](#5-blog-website)
  - [Hospital Management](#6-hospital-management)
  - [API Service](#7-api-service)
  - [Document Intelligence Platform](#8-document-intelligence-platform)
  - [Social Media App](#9-social-media-app)
- [Technology Stack](#-technology-stack)
- [Infrastructure & DevOps](#-infrastructure--devops)
- [Getting Started](#-getting-started)
- [Routing Map](#-routing-map)
- [Observability & Debugging](#-observability--debugging)
- [Project Structure](#-project-structure)
- [Screenshots](#-screenshots)

---

## 🌐 Overview

This repository is a **personal development cluster** — a collection of independently built, production-grade full-stack projects unified under a single Nginx gateway. Every app is containerized, infrastructure is managed as code with Terraform, and the entire cluster can be provisioned or destroyed with a single command.

| | |
|---|---|
| **Total Applications** | 9 |
| **Backend Languages** | Python, Java, Go, Node.js |
| **Frontend** | React + Vite |
| **Databases** | PostgreSQL, MySQL, SQLite, Redis |
| **Object Storage** | MinIO (S3-compatible) |
| **Containers** | Docker |
| **Orchestration** | Kubernetes via `kind` |
| **IaC** | Terraform |
| **Gateway** | Nginx |
| **AI / LLM** | Google Gemini API, Ollama |

---

## 🏗️ Architecture

```
                     ┌──────────────────────────────────┐
                     │        Nginx Gateway :80          │
                     │   localhost  —  Single Entry      │
                     └────────────────┬─────────────────┘
                                      │
        ┌─────────────────────────────┼──────────────────────────────┐
        │                            │                              │
  ┌─────▼──────┐             ┌───────▼──────┐             ┌─────────▼──────┐
  │  /notes/   │             │   /bank/     │             │   /quiz/        │
  │  Django    │             │ Spring Boot  │             │ React (static)  │
  │ PostgreSQL │             │ PostgreSQL   │             └────────────────┘
  └────────────┘             └──────────────┘
  ┌────────────┐             ┌──────────────┐             ┌────────────────┐
  │  /video/   │             │  /hospital/  │             │   /blog/        │
  │  Node.js   │             │   Django     │             │   Django        │
  └────────────┘             │   SQLite     │             │ MySQL + MinIO   │
                             └──────────────┘             └────────────────┘
  ┌────────────┐             ┌──────────────┐             ┌────────────────┐
  │/api-service│             │  /document/  │             │   /social/      │
  │  Node.js   │             │  Django      │             │  → kind cluster │
  │  Express   │             │MySQL + MinIO │             └────────────────┘
  └────────────┘             │ Gemini + LLM │
                             └──────────────┘

                          Social Media App — kind cluster
                    ┌──────────────────────────────────────┐
                    │  Django · Go MS · Java MS · React     │
                    │  PostgreSQL · Redis · MinIO           │
                    │  ingress-nginx (Helm) on NodePort     │
                    └──────────────────────────────────────┘
```

All Docker containers share the `gateway-net` bridge network. The Social Media App runs inside a `kind` Kubernetes cluster, and the gateway container is connected to both networks so traffic flows seamlessly.


---

## 📦 Projects

### 1. Notes App

A full-stack note-taking application with a Django REST API and a React frontend.

![alt text](image.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Django (Python) |
| Database | PostgreSQL 16 |
| URL | `http://localhost/notes/` |

**Features:**
- Create, read, update, and delete notes
- REST API served by Django REST Framework
- Persistent data in PostgreSQL

---

### 2. Bank Manager

A banking management system with a Java Spring Boot backend and a React frontend.

![alt text](image-1.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Spring Boot (Java) |
| Database | PostgreSQL 16 Alpine |
| URL | `http://localhost/bank/` |

**Features:**
- Account and transaction management
- Spring Data JPA with PostgreSQL
- REST API with Spring MVC

---

### 3. Quiz App

A static frontend quiz game on general Computer Science topics — no backend required.

![alt text](image-2.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | None (static) |
| URL | `http://localhost/quiz/` |

**Features:**
- 5-question CS trivia quiz
- Fully client-side — no database, no API calls
- Nginx serves the compiled static bundle directly

---

### 4. Video Uploader

A video upload and streaming application with a Node.js backend.

![alt text](image-3.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Node.js |
| Storage | Local filesystem (`/app/Uploads`) |
| URL | `http://localhost/video/` |

**Features:**
- Upload and manage video files
- Files served via Node.js
- Gateway supports up to 1 GB uploads (`client_max_body_size 1000M`)

---

### 5. Blog Website

A full-featured blog platform with user authentication and cloud media storage.

![alt text](image-4.png)

| Layer | Technology |
|-------|-----------|
| Backend | Django (Python) |
| Database | MySQL 8.0 |
| Media Storage | MinIO (S3-compatible) |
| URL | `http://localhost/blog/` |

**Features:**
- User login/logout with Django authentication
- Rich post creation with image uploads
- Media stored in MinIO, served publicly via `http://localhost/blog/minio/`
- Django admin panel at `/blog/admin/`

---

### 6. Hospital Management

A Django-based hospital management system using Django admin and template views.

![alt text](image-5.png)

| Layer | Technology |
|-------|-----------|
| Backend | Django (Python) |
| Database | SQLite |
| URL | `http://localhost/hospital/` |

**Features:**
- Patient and appointment tracking
- Django template-based views
- Lightweight setup with SQLite — no separate DB container needed

---

### 7. API Service

A Node.js/Express backend that aggregates data from external APIs, with a React frontend.

![alt text](image-6.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Node.js + Express |
| External API | OpenWeatherMap |
| URL | `http://localhost/api-service/` |

**Features:**
- Live weather data via OpenWeatherMap API
- Express routes serving structured JSON
- React frontend for interactive API exploration

---

### 8. Document Intelligence Platform

An AI-powered document analysis platform where users can upload documents and query them using LLMs.

![alt text](image-7.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Django (Python) |
| Database | MySQL 8.0 |
| Object Storage | MinIO |
| AI | Google Gemini API + Ollama (local LLM) |
| URL | `http://localhost/document/` |

**Features:**
- Upload PDF and document files, stored in MinIO
- AI-powered Q&A on document content via Gemini API
- Local LLM inference via Ollama running on the host (`host.docker.internal`)
- Extended gateway timeout (120s) for large inference requests

---

### 9. Social Media App

The most complex project — a microservices-based social platform deployed on a local **Kubernetes** cluster via `kind`.

![alt text](image-8.png)

| Component | Technology |
|-----------|-----------|
| Frontend | React (served via Nginx) |
| Backend API | Django (Python) |
| Microservice — Go | Handles caching/real-time layer |
| Microservice — Java | Spring Boot, domain-specific logic |
| Database | PostgreSQL 15 (K8s StatefulSet) |
| Cache | Redis 7 |
| Object Storage | MinIO |
| Orchestration | Kubernetes via `kind` |
| Ingress | ingress-nginx (deployed via Helm) |
| URL | `http://localhost/social/` |

**Features:**
- Posts, feeds, and user interactions
- Go microservice integrates with Redis for caching
- Java microservice handles separate business domains
- Media uploads stored in MinIO
- Full Kubernetes deployment with Ingress-based routing
- Gateway bridges to kind cluster via `docker network connect kind gateway`

> Prometheus, Grafana, Loki, Tempo, and Promtail observability stack is scaffolded and ready to enable — currently commented out in `main.tf` to conserve local resources.

---

## 🛠️ Technology Stack

### Languages

| Language | Used In |
|----------|---------|
| Python | Notes, Blog, Hospital, Document, Social (Django) |
| Java | Bank Manager (Spring Boot), Social (Java microservice) |
| Go | Social Media (Go microservice) |
| JavaScript / Node.js | API Service, Video Uploader |
| TypeScript / JSX | All React + Vite frontends |

### Frameworks & Libraries

| Framework | Role |
|-----------|------|
| Django | REST APIs and template-based backends |
| Spring Boot | Bank Manager and Social Java microservice |
| React + Vite | All frontend SPAs |
| Express.js | API Service backend |

### Databases

| Database | Used By |
|----------|---------|
| PostgreSQL 16 | Notes App, Bank Manager |
| PostgreSQL 15 | Social Media App (Kubernetes StatefulSet) |
| MySQL 8.0 | Blog Website, Document Intelligence Platform |
| SQLite | Hospital Management |
| Redis 7 | Social Media App (caching layer) |

### Infrastructure

| Tool | Purpose |
|------|---------|
| Docker | Containerization of all services |
| Terraform | Full cluster IaC — images, containers, volumes, K8s |
| Kubernetes (`kind`) | Local K8s cluster for Social Media App |
| Helm | Deploys ingress-nginx into the kind cluster |
| Nginx | API Gateway — single entry point for all apps |
| MinIO | S3-compatible object storage (Blog, Document, Social) |

### AI / ML

| Tool | Purpose |
|------|---------|
| Google Gemini API | Document Q&A and intelligence |
| Ollama | Self-hosted local LLM inference |

---

## ⚙️ Infrastructure & DevOps

### Terraform

The entire cluster is managed as Infrastructure as Code. Terraform handles Docker image builds (with SHA-based triggers so images only rebuild when source changes), container lifecycle, Kubernetes manifests, and Helm releases.

```bash
# Initialize Terraform providers
terraform init

# Preview what will be created/changed/destroyed
terraform plan

# Provision the entire cluster (first run takes ~5–10 min for image builds)
terraform apply

# Tear everything down
terraform destroy
```

### Smart Rebuild Triggers

Each Docker image resource uses a `dir_sha` trigger — a hash of all source files. Terraform only rebuilds an image if the source code actually changed:

```hcl
triggers = {
  dir_sha = sha256(join("", [
    for f in fileset("path/to/source", "**") :
    filesha256("path/to/source/${f}")
    if !can(regex("(__pycache__|node_modules|dist|\\.git)", f))
  ]))
}
```

### kind + Gateway Network Bridge

The gateway container is connected to both `gateway-net` and the `kind` Docker network, allowing Nginx to proxy `/social/` traffic directly into the kind cluster:

```bash
# Verify the bridge
docker network inspect kind | grep gateway

# Manual bridge (Terraform does this automatically)
docker network connect kind gateway
```

---

## 🚀 Getting Started

### Prerequisites

| Tool | Install |
|------|---------|
| Docker Desktop | https://docs.docker.com/desktop/ |
| Terraform | https://developer.hashicorp.com/terraform/install |
| `kind` | https://kind.sigs.k8s.io/docs/user/quick-start/ |
| `kubectl` | https://kubernetes.io/docs/tasks/tools/ |
| `helm` | https://helm.sh/docs/intro/install/ |

### Bring Up the Cluster

```bash
# 1. Clone the repo
git clone <your-repo-url>
cd <repo>/infrastructure/gateway    # adjust to your Terraform root

# 2. Initialize Terraform
terraform init

# 3. Review the plan
terraform plan

# 4. Provision everything
terraform apply
```

All 9 apps will be live at `http://localhost/<app>/` once provisioned.

### Tear Down

```bash
terraform destroy
```

---

## 🗺️ Routing Map

All traffic enters through Nginx on port `80` and is proxied to the appropriate backend.

| URL | App | Backend Target |
|-----|-----|---------------|
| `http://localhost/` | Gateway status | JSON response (inline) |
| `http://localhost/notes/` | Notes App | `notes-backend:8000` |
| `http://localhost/notes/api/` | Notes REST API | `notes-backend:8000` → `/api/` |
| `http://localhost/bank/` | Bank Manager | `bank-backend:8080` |
| `http://localhost/bank/api/` | Bank REST API | `bank-backend:8080` → `/api/` |
| `http://localhost/quiz/` | Quiz App | Static files |
| `http://localhost/video/` | Video Uploader | `video-uploader-backend:8080` |
| `http://localhost/hospital/` | Hospital Management | `hospital-management:8000` |
| `http://localhost/blog/` | Blog Website | `blog-website:8000` |
| `http://localhost/blog/minio/` | Blog media files | `blog-minio:9000` |
| `http://localhost/api-service/` | API Service | `api-service-backend:8000` |
| `http://localhost/document/` | Document Platform | `doc-backend:8000` |
| `http://localhost/social/` | Social Media App | `kind` cluster → ingress-nginx |
| `http://localhost/social/api/` | Social REST API | `kind` → Django backend pod |
| `http://localhost/social/minio/` | Social media files | `kind` → MinIO pod |

### Gateway Health Check

```bash
curl http://localhost/
# {"status":"gateway running","apps":["/notes/","/bank/","/quiz/","/video/","/hospital/","/blog/","/social/","/api-service/","/document/"]}
```

---

## 🔍 Observability & Debugging

### Docker — Container Status

```bash
# All running containers
docker ps

# All containers including stopped/exited ones
docker ps -a

# Resource usage (CPU, memory, network) live
docker stats
```

### Docker — Application Logs

```bash

# Follow logs in real time
docker logs -f <container-name-from-ps>

# Show only the last 100 lines
docker logs --tail 100 <container-name>

# Show logs with timestamps
docker logs -t <container-name>
```

### Docker — Shell Access & Inspection

```bash
# Open a shell inside any running container
docker exec -it <container-name> bash     # Debian/Ubuntu-based
docker exec -it <container-name> sh       # Alpine-based

# Inspect container config, mounts, network settings
docker inspect <container-name>

# List all named volumes
docker volume ls

# Inspect a specific volume
docker volume inspect gateway_notes-pgdata

# Inspect the gateway network
docker network inspect gateway-net
```

### Docker — Database Access

```bash
# Notes PostgreSQL
docker exec -it notes-postgres psql -U saisakthi -d notes_app

# Bank PostgreSQL
docker exec -it bank-postgres psql -U bankmanagement -d bank

# Blog MySQL
docker exec -it blog-db mysql -u root -psaisakthi2008 blog_db

# Document MySQL
docker exec -it doc-mysql mysql -u root -psaisakthi2008 book_db
```

### Nginx — Routing Debug

```bash
# Test Nginx config for syntax errors
docker exec gateway nginx -t

# Reload Nginx config without downtime
docker exec gateway nginx -s reload

# Test a specific route manually
curl -v http://localhost/notes/api/
```

### Kubernetes — Pod & Service Status

```bash
# All pods across all namespaces
kubectl get pods -A

# Pods in the default namespace (Social Media App)
kubectl get pods

# Full details on a specific pod (great for Pending or CrashLoopBackOff)
kubectl describe pod <pod-name>

# All services
kubectl get services

# All deployments
kubectl get deployments

# Ingress rules
kubectl get ingress
kubectl describe ingress social-media-api-ingress
kubectl describe ingress social-media-frontend-ingress
```

### Kubernetes — Pod Logs

```bash
# Django backend
kubectl logs deployment/deployment-name
```

### Kubernetes — Shell Access

```bash
# Shell into the Django backend pod
kubectl exec -it deployment/backend -- bash

# Shell into PostgreSQL
kubectl exec -it statefulset/postgres -- psql -U admin -d socialdb

# Shell into Redis CLI
kubectl exec -it deployment/redis -- redis-cli

# Shell into Go microservice
kubectl exec -it deployment/microservice-go -- sh
```

### Kubernetes — kind Cluster Management

```bash
# List all kind clusters
kind get clusters

# View kind cluster nodes (these are Docker containers)
kubectl get nodes
docker ps | grep social-media

# Load a locally built image into the kind cluster manually
kind load docker-image socialmediaapp-django:latest --name social-media

# Delete and recreate the cluster
kind delete cluster --name social-media
kind create cluster --config infrastructure/kind/kind-config.yaml
```

### Terraform — State & Drift

```bash
# Check if real infrastructure drifted from Terraform state
terraform plan

# Show current Terraform state
terraform show

# List all managed resources
terraform state list

# Force-refresh Terraform state from real infrastructure
terraform refresh

# Manually remove a resource from state (without destroying it)
terraform state rm <resource.name>

# Import an existing resource into Terraform state
terraform import <resource.name> <resource-id>
```

---

## 📁 Project Structure

```
.
├── API Service/
│   ├── backend/                    # Node.js + Express
│   │   ├── app.js
│   │   ├── routes/
│   │   └── Dockerfile
│   └── frontend/api-service/       # React + Vite
│
├── Bank Manager/
│   ├── backend/bank_management/    # Spring Boot (Java)
│   └── frontend/                   # React + Vite
│
├── Blog Website/
│   ├── blogsite/                   # Django project
│   ├── Dockerfile
│   └── entrypoint.sh
│
├── Document Intelligence Platform/
│   ├── backend/document_backend/   # Django + Gemini + Ollama
│   ├── frontend/document_frontend/ # React + Vite
│   └── storage/minio/
│
├── gateway/
│   └── nginx/default.conf          # Nginx gateway — all routing lives here
│
├── hospital_management/            # Django + SQLite
│
├── Notes App/
│   ├── backend/                    # Django
│   └── frontend/notes_app_frontend/ # React + Vite
│
├── Quiz App/
│   └── quiz-app/                   # React + Vite (fully static)
│
├── Social Media App/
│   ├── apps/
│   │   ├── backend/                # Django
│   │   ├── frontend/               # React
│   │   ├── microservice-go/        # Go microservice
│   │   └── microservice-java/      # Spring Boot microservice
│   ├── infrastructure/
│   │   └── kind/                   # kind cluster config YAML
│   ├── platform/
│   │   └── observability/          # Prometheus, Loki, Tempo, Promtail configs
│   └── storage/minio/
│
├── Video Uploader/
│   └── Main/
│       ├── backend/                # Node.js
│       └── frontend/               # React + Vite
│
└── infrastructure/
    └── gateway/
        ├── main.tf                 # Terraform — entire cluster as code
        └── nginx/default.conf
```



## 📝 Notes

- All credentials in this repo are for **local development only**. Do not use them in any public or production environment.
- The `kind` cluster must already exist before running `terraform apply` if the Social Media resources exist in Terraform state. Terraform will create it if it doesn't exist.
- Frontend containers marked `must_run = false` / `restart = no` are one-shot build containers — they copy compiled static assets into a named volume and exit cleanly. This is expected behaviour.
- The full **observability stack** (Cassandra, Prometheus, Grafana, Loki, Tempo, Promtail) is scaffolded in `main.tf` but commented out because it is in development.

---

<p align="center">
  Built and maintained by <strong>Saisakthi</strong> &nbsp;·&nbsp; Local development cluster &nbsp;·&nbsp; Not for production use
</p>
