variable "name" {}
variable "image" {}
variable "internal_port" { type = number }
variable "external_port" { type = number }
variable "network" { type = string }

variable "env" {
  type    = list(string)
  default = []
}

variable "volumes" {
  type = list(object({
    host_path      = string
    container_path = string
    read_only      = bool
  }))
  default = []
}
