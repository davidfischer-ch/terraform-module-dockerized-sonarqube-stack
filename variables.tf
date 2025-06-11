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

# Networking ---------------------------------------------------------------------------------------

variable "hosts" {
  type        = map(string)
  default     = {}
  description = "Add entries to container hosts file."
}

variable "https_port" {
  type        = number
  description = "Bind the reverse proxy's HTTPS port."
}

variable "http_port" {
  type        = number
  description = "Bind the reverse proxy's HTTP port."
}

# Reverse Proxy ------------------------------------------------------------------------------------

variable "dhparam_use_dsa" {
  type        = bool
  default     = false
  description = <<EOT
    Use DSA (converted to DH) instead of "pure" DH params (DH by default).
    Much faster to generate but using "weaker" prime numbers.

    See https://docs.openssl.org/3.4/man1/openssl-dhparam/#options
  EOT
}
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

# SonarQube Application ----------------------------------------------------------------------------

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

# Images -------------------------------------------------------------------------------------------

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

# Database Container -------------------------------------------------------------------------------

variable "postgresql_max_connections" {
  type    = number
  default = 100
}

# Reverse Proxy Container --------------------------------------------------------------------------

variable "nginx_log_level" {
  type    = string
  default = "warn"
}

variable "nginx_modules" {
  type    = list(string)
  default = []
}
