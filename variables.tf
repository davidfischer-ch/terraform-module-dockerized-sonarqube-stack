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
  default     = true
}

variable "wait" {
  type        = bool
  description = <<EOT
    Wait for the containers to reach an healthy state after creation.
    Current restriction: Applies only for Nginx and PostgreSQL.
  EOT
  default     = true
}
# Process ------------------------------------------------------------------------------------------

variable "app_image_name" {
  type        = string
  description = "SonarQube application's image name."
}

# Networking ---------------------------------------------------------------------------------------

variable "hosts" {
  type        = map(string)
  description = "Add entries to container hosts file."
  default     = {}
}

variable "https_port" {
  type        = number
  description = "Bind the reverse proxy's HTTPS port."

  validation {
    condition     = var.https_port >= 1 && var.https_port <= 65535
    error_message = "Argument `https_port` must be between 1 and 65535."
  }
}

variable "http_port" {
  type        = number
  description = "Bind the reverse proxy's HTTP port."

  validation {
    condition     = var.http_port >= 1 && var.http_port <= 65535
    error_message = "Argument `http_port` must be between 1 and 65535."
  }
}

# Reverse Proxy ------------------------------------------------------------------------------------

variable "dhparam_use_dsa" {
  type        = bool
  description = <<EOT
    Use DSA (converted to DH) instead of "pure" DH params (DH by default).
    Much faster to generate but using "weaker" prime numbers.

    See https://docs.openssl.org/3.4/man1/openssl-dhparam/#options
  EOT
  default     = false
}
variable "ssl_crt" {
  type        = string
  description = "TLS certificate content (PEM format)."
}

variable "ssl_key" {
  type        = string
  description = "TLS private key content (PEM format)."
}

variable "max_body_size" {
  type        = string
  description = "Maximum allowed size of the client request body (default: \"20M\")."
  default     = "20M"
}

# Storage ------------------------------------------------------------------------------------------

variable "data_directory" {
  type        = string
  description = "Where data will be persisted (volumes will be mounted as sub-directories)."
}

# SonarQube Application ----------------------------------------------------------------------------

variable "settings" {
  type        = map(string)
  description = "Any additional environment variables for the application (e.g. { FOO = \"bar\" })"
  default     = {}
}

variable "debug" {
  type        = bool
  description = "Enable SonarQube debug mode."
  default     = false
}

variable "domains" {
  type        = list(string)
  description = "Allowed domains for the application (used in nginx server_name)."
}

# Database Container -------------------------------------------------------------------------------

variable "postgresql_image_name" {
  type        = string
  description = "PostgreSQL image name."
  default     = "postgres:latest"
}

variable "postgresql_uid" {
  type        = number
  description = "UID of the user running the database container and owning the data directories."
  default     = 999
}

variable "postgresql_gid" {
  type        = number
  description = "GID of the user running the database container and owning the data directories."
  default     = 0
}

variable "postgresql_max_connections" {
  type        = number
  description = "Maximum number of PostgreSQL connections."
  default     = 100

  validation {
    condition     = var.postgresql_max_connections >= 1 && var.postgresql_max_connections <= 262143
    error_message = "Argument `postgresql_max_connections` should be between 1 and 262143."
  }
}

# Reverse Proxy Container --------------------------------------------------------------------------

variable "nginx_image_name" {
  type        = string
  description = "Nginx image name."
  default     = "nginx:latest"
}

variable "nginx_uid" {
  type        = number
  description = <<EOT
    UID of the user running the reverse-proxy container.
    If not root then NET_IND_SERVICE capability will be added for nginx to bind ports 80/443.
  EOT
  default     = 0
}

variable "nginx_gid" {
  type        = number
  description = <<EOT
    GID of the user running the reverse-proxy container.
    If not root then NET_IND_SERVICE capability will be added for nginx to bind ports 80/443.
  EOT
  default     = 0
}

variable "nginx_log_level" {
  type        = string
  description = "Nginx error log level."
  default     = "warn"
}

variable "nginx_modules" {
  type        = list(string)
  description = "Nginx modules to enable."
  default     = []
}
