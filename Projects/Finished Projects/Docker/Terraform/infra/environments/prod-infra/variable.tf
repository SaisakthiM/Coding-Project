# ─── n8n ────────────────────────────────────────────────────
variable "main_server_ip" {
  description = "IP of your main server — used by n8n to reach apps"
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

# ─── Observability ──────────────────────────────────────────
variable "observability_redis_password" {
  description = "Password for the Bitnami redis used by the observability stack. Originally hardcoded as a literal in the helm_release; now a real variable backing a Terraform-managed Secret."
  type        = string
  sensitive   = true
  default     = "redis-password" # TODO: rotate -- this matched the old hardcoded value, change it
}

variable "gitops_repo_url" {
  description = "Git URL ArgoCD pulls gitops/ from. Must match prod-social's value and the repo you actually push to."
  type        = string
  default     = "git@github.com:SaisakthiM/Coding-Project.git"
}
