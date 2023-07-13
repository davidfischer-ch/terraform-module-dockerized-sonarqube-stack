terraform {
  required_version = ">= 1.4"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.23.0"
    }
  }
}
