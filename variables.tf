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

variable "http_port" {
  type = number
}

# SonarQube Application

variable "settings" {
  type        = map(string)
  default     = {}
  description = "Any additional environment variables for the application (e.g. { FOO = \"bar\" })"
}

# Images

variable "app_image_name" {
  type        = string
  description = "SonarQube application's image name"
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
