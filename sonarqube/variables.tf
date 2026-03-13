variable "identifier" {
  type = string
}

variable "enabled" {
  type = bool
}

variable "image_id" {
  type        = string
  description = "SonarQube application's image ID."
}

# Networking ---------------------------------------------------------------------------------------

variable "hosts" {
  type        = map(string)
  default     = {}
  description = "Add entries to container hosts file."
}

variable "network_id" {
  type = string
}

variable "port" {
  type    = number
  default = 9000

  validation {
    condition     = var.port == 9000
    error_message = "Having `port` different than 9000 is not yet implemented."
  }
}

# Storage ------------------------------------------------------------------------------------------

variable "data_directory" {
  type = string
}

# SonarQube Application ----------------------------------------------------------------------------

variable "settings" {
  type        = map(string)
  default     = {}
  description = "Any additional environment variables for the application (e.g. { FOO = \"bar\" })"
}

# Database Endpoint --------------------------------------------------------------------------------

variable "database_host" {
  type = string
}

variable "database_port" {
  type    = number
  default = 5432
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type      = string
  sensitive = true
}
