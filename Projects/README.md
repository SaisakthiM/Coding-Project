# 🧩 Full-Stack Project Cluster

> A unified, production-style monorepo hosting **9 full-stack applications** behind a single Nginx API gateway — provisioned entirely with **Terraform**, deployed across **Docker** and **Kubernetes (kind)**.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Projects](#-projects)
- [Technology Stack](#-technology-stack)
- [Infrastructure & DevOps](#-infrastructure--devops)
- [Getting Started](#-getting-started)
- [Routing Map](#-routing-map)
- [Project Structure](#-project-structure)

---

## 🌐 Overview

A **personal development cluster** — a collection of independently built, production-grade full-stack projects unified under a single Nginx gateway. Every app is containerized, infrastructure is managed as code with Terraform, and the entire cluster can be provisioned or torn down with a single command.

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

### 0. Intro Page

![Intro Page](../Projects/images/image-intro.png)

| Layer | Technology |
|-------|-----------|
| Type | Static HTML |
| URL | `http://localhost/intro/` |

The cluster landing page — an overview of all 9 apps with live links, architecture diagram, and tech stack. Provisioned automatically via Terraform using a `null_resource` that copies `intro/index.html` into the gateway volume.

---

### 1. Notes App

![Notes App](../Projects/images/image-notes.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Django (Python) |
| Database | PostgreSQL 16 |
| URL | `http://localhost/notes/` |

Create, read, update, and delete notes via a Django REST Framework API with persistent PostgreSQL storage.

---

### 2. Bank Manager

![Bank Manager](../Projects/images/image-bank.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Spring Boot (Java) |
| Database | PostgreSQL 16 Alpine |
| URL | `http://localhost/bank/` |

Account and transaction management with Spring Data JPA and a REST API built on Spring MVC.

---

### 3. Quiz App

![Quiz App](../Projects/images/image-quiz.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | None (static) |
| URL | `http://localhost/quiz/` |

A fully client-side CS trivia quiz — no database, no API calls. Nginx serves the compiled static bundle directly.

---

### 4. Video Uploader

![Video Uploader](../Projects/images/image-video.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Node.js |
| Storage | Local filesystem (`/app/Uploads`) |
| URL | `http://localhost/video/` |

Upload and stream video files via Node.js. The gateway supports up to 1 GB uploads.

---

### 5. Blog Website

![Blog Website](../Projects/images/image-blog.png)

| Layer | Technology |
|-------|-----------|
| Backend | Django (Python) |
| Database | MySQL 8.0 |
| Media Storage | MinIO (S3-compatible) |
| URL | `http://localhost/blog/` |

Full-featured blog with Django authentication, rich post creation, image uploads to MinIO, and an admin panel at `/blog/admin/`.

---

### 6. Hospital Management

![Hospital Management](../Projects/images/image-hospital.png)

| Layer | Technology |
|-------|-----------|
| Backend | Django (Python) |
| Database | SQLite |
| URL | `http://localhost/hospital/` |

Patient and appointment tracking using Django admin and template-based views. Lightweight — no separate DB container needed.

---

### 7. API Service

![API Service](../Projects/images/image-api.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Node.js + Express |
| External API | OpenWeatherMap |
| URL | `http://localhost/api-service/` |

Live weather data via OpenWeatherMap, served through Express routes with a React frontend for interactive exploration.

---

### 8. Document Intelligence Platform

![Document Intelligence Platform](../Projects/images/image-document.png)

| Layer | Technology |
|-------|-----------|
| Frontend | React + Vite |
| Backend | Django (Python) |
| Database | MySQL 8.0 |
| Object Storage | MinIO |
| AI | Google Gemini API + Ollama (local LLM) |
| URL | `http://localhost/document/` |

Upload PDF documents stored in MinIO and run AI-powered Q&A against them via Gemini API or local Ollama inference. Gateway timeout is extended to 120s for large inference requests.

---

### 9. Social Media App

![Social Media App](../Projects/images/image-social.png)

| Component | Technology |
|-----------|-----------|
| Frontend | React (served via Nginx) |
| Backend API | Django (Python) |
| Microservice — Go | Caching / real-time layer (Redis) |
| Microservice — Java | Spring Boot, domain-specific logic |
| Database | PostgreSQL 15 (K8s StatefulSet) |
| Cache | Redis 7 |
| Object Storage | MinIO |
| Orchestration | Kubernetes via `kind` |
| Ingress | ingress-nginx (Helm) |
| URL | `http://localhost/social/` |

The most complex project — a microservices platform running on a local Kubernetes cluster. The gateway bridges to the `kind` network so `/social/` traffic proxies directly into the cluster's ingress controller.

> The Prometheus, Grafana, Loki, Tempo, and Promtail observability stack is scaffolded and ready to enable — currently commented out in `main.tf` to conserve local resources.

---

## 🛠️ Technology Stack

| Language | Used In |
|----------|---------|
| Python | Notes, Blog, Hospital, Document, Social (Django) |
| Java | Bank Manager (Spring Boot), Social (Java microservice) |
| Go | Social Media (Go microservice) |
| JavaScript / Node.js | API Service, Video Uploader |
| TypeScript / JSX | All React + Vite frontends |

| Database | Used By |
|----------|---------|
| PostgreSQL 16 | Notes App, Bank Manager |
| PostgreSQL 15 | Social Media App (K8s StatefulSet) |
| MySQL 8.0 | Blog Website, Document Intelligence Platform |
| SQLite | Hospital Management |
| Redis 7 | Social Media App (caching layer) |

| Tool | Purpose |
|------|---------|
| Docker | Containerization of all services |
| Terraform | Full cluster IaC — images, containers, volumes, K8s manifests |
| Kubernetes (`kind`) | Local K8s cluster for Social Media App |
| Helm | Deploys ingress-nginx into the kind cluster |
| Nginx | API Gateway — single entry point for all apps |
| MinIO | S3-compatible object storage (Blog, Document, Social) |
| Google Gemini API | Document Q&A |
| Ollama | Self-hosted local LLM inference |

---

## ⚙️ Infrastructure & DevOps

### Terraform

The entire cluster is managed as Infrastructure as Code. Terraform handles Docker image builds, container lifecycle, Kubernetes manifests, and Helm releases.

```bash
terraform init       # initialise providers
terraform plan       # preview changes
terraform apply      # provision everything (~5–10 min on first run)
terraform destroy    # tear everything down
```

### Smart Rebuild Triggers

Each Docker image uses a `dir_sha` trigger — a hash of all source files. Images only rebuild when source code actually changes:

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

The gateway container connects to both `gateway-net` and the `kind` Docker network, routing `/social/` traffic directly into the cluster:

```bash
docker network connect kind gateway   # Terraform handles this automatically
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
git clone <your-repo-url>
cd <repo>/infrastructure/gateway

terraform init
terraform apply
```

All apps will be live at `http://localhost/<app>/` once provisioned.

### Tear Down

```bash
terraform destroy
```

---

## 🗺️ Routing Map

| URL | App | Backend |
|-----|-----|---------|
| `http://localhost/intro/` | Intro Page | Static |
| `http://localhost/notes/` | Notes App | `notes-backend:8000` |
| `http://localhost/notes/api/` | Notes REST API | `notes-backend:8000` → `/api/` |
| `http://localhost/bank/` | Bank Manager | `bank-backend:8080` |
| `http://localhost/bank/api/` | Bank REST API | `bank-backend:8080` → `/api/` |
| `http://localhost/quiz/` | Quiz App | Static |
| `http://localhost/video/` | Video Uploader | `video-uploader-backend:8080` |
| `http://localhost/hospital/` | Hospital Management | `hospital-management:8000` |
| `http://localhost/blog/` | Blog Website | `blog-website:8000` |
| `http://localhost/blog/minio/` | Blog media files | `blog-minio:9000` |
| `http://localhost/api-service/` | API Service | `api-service-backend:8000` |
| `http://localhost/document/` | Document Platform | `doc-backend:8000` |
| `http://localhost/social/` | Social Media App | `kind` → ingress-nginx |
| `http://localhost/social/api/` | Social REST API | `kind` → Django pod |
| `http://localhost/social/minio/` | Social media files | `kind` → MinIO pod |

### Gateway Health Check

```bash
curl http://localhost/
# {"status":"gateway running","apps":["/notes/","/bank/","/quiz/","/video/","/hospital/","/blog/","/social/","/api-service/","/document/"]}
```

---

## 📁 Project Structure

```
.
├── API Service/
│   ├── backend/                    # Node.js + Express
│   └── frontend/api-service/       # React + Vite
│
├── Bank Manager/
│   ├── backend/bank_management/    # Spring Boot (Java)
│   └── frontend/                   # React + Vite
│
├── Blog Website/
│   ├── blogsite/                   # Django project
│   └── Dockerfile
│
├── Document Intelligence Platform/
│   ├── backend/document_backend/   # Django + Gemini + Ollama
│   ├── frontend/document_frontend/ # React + Vite
│   └── storage/minio/
│
├── gateway/
│   └── nginx/default.conf          # All routing lives here
│
├── hospital_management/            # Django + SQLite
│
├── intro/
│   └── index.html                  # Cluster intro page (static)
│
├── images/                         # Project screenshots
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
│   ├── infrastructure/kind/        # kind cluster config YAML
│   ├── platform/observability/     # Prometheus, Loki, Tempo, Promtail configs
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

---

## 📝 Notes

- All credentials in this repo are for **local development only**. Do not use them in any public or production environment.
- The `kind` cluster must already exist before running `terraform apply` if the Social Media resources exist in Terraform state. Terraform will create it automatically if it doesn't.
- Frontend containers marked `must_run = false` / `restart = no` are one-shot build containers — they copy compiled static assets into a named volume and exit. This is expected behaviour.
- The full observability stack (Prometheus, Grafana, Loki, Tempo, Promtail) is scaffolded in `main.tf` but commented out — ready to enable when needed.

---

<p align="center">
  Built and maintained by <strong>Saisakthi</strong> &nbsp;·&nbsp; Local development cluster &nbsp;·&nbsp; Not for production use
</p>