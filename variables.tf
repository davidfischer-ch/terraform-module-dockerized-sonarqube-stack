variable "identifier" {
  type        = string
  description = "Identifier (must be unique, used to name resources)."
  validation {
    condition     = regex("^[a-z]+(-[a-z0-9]+)*$", var.identifier) != null
    error_message = "Argument `identifier` must match regex ^[a-z]+(-[a-z0-9]+)*$."
  }
}

variable "enabled" {
  type        = bool
  description = "Toggle the containers (started or stopped)."
}

variable "data_directory" {
  type        = string
  description = "Where data will be persisted (volumes will be mounted as sub-directories)."
}

# Networking

variable "https_port" {
  type        = number
  description = "Bind the reverse proxy's HTTPS port."
}

variable "http_port" {
  type        = number
  description = "Bind the reverse proxy's HTTP port."
}

# Reverse Proxy

variable "ssl_crt" {
  type = string
}

variable "ssl_key" {
  type = string
}

variable "max_body_size" {
  type    = string
  default = "20M"
}

# SonarQube Application

variable "settings" {
  type        = map(string)
  default     = {}
  description = "Any additional environment variables for the application (e.g. { FOO = \"bar\" })"
}

variable "debug" {
  type = bool
}

variable "domains" {
  type = list(string)
}

# Images

variable "app_image_name" {
  type        = string
  description = "SonarQube application's image name"
}

variable "nginx_image_name" {
  type    = string
  default = "nginx:latest"
}

variable "postgresql_image_name" {
  type    = string
  default = "postgres:latest"
}

# Database Container

variable "postgresql_max_connections" {
  type    = number
  default = 100
}

# Reverse Proxy Container

variable "nginx_log_level" {
  type    = string
  default = "warn"
}

variable "nginx_modules" {
  type    = list(string)
  default = []
}
