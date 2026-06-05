# ─── BLOG ─────────────────────────────────────────────────────
variable "blog_db_password"    { sensitive = true }
variable "blog_db_name"        {}
variable "blog_minio_user"     {}
variable "blog_minio_password" { sensitive = true }
variable "blog_secret_key"     { sensitive = true }
variable "blog_allowed_hosts"  {}

# ─── NOTES ────────────────────────────────────────────────────
variable "notes_db_name"       {}
variable "notes_db_user"       {}
variable "notes_db_password"   { sensitive = true }

# ─── BANK ─────────────────────────────────────────────────────
variable "bank_db_user"        {}
variable "bank_db_password"    { sensitive = true }
variable "bank_db_name"        {}

# ─── DOCUMENT INTELLIGENCE PLATFORM ──────────────────────────
variable "doc_db_password"     { sensitive = true }
variable "doc_db_name"         {}
variable "doc_minio_user"      {}
variable "doc_minio_password"  { sensitive = true }
variable "doc_gemini_api_key"  { sensitive = true }
variable "doc_django_secret_key" { sensitive = true }

# ─── API SERVICE ──────────────────────────────────────────────
variable "api_key_weather"     { sensitive = true }

# ─── SOCIAL MEDIA ─────────────────────────────────────────────
variable "social_db_user"      {}
variable "social_db_password"  { sensitive = true }
variable "social_db_name"      {}
variable "social_minio_user"   {}
variable "social_minio_password" { sensitive = true }
variable "load_images" {
  type    = bool
  default = false
}

# ─── n8n variables — add these to your existing variables.tf ──

variable "main_server_ip" {
  description = "IP of your main server (192.168.31.227) — used by n8n to reach apps"
  type        = string
  default     = "192.168.31.227"
}

variable "domain" {
  description = "Your public domain"
  type        = string
  default     = "saisakthi.qzz.io"
}

variable "n8n_env" {
  description = "Environment variables for the n8n container"
  type        = map(string)
}


