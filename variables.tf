variable "identifier" {
  type = string
}

variable "enabled" {
  type = bool
}

variable "data_directory" {
  type = string
}

# Networking

variable "https_port" {
  type = number
}

variable "http_port" {
  type = number
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
