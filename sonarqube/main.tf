resource "docker_container" "server" {

  # TODO Handle multiple application nodes

  image = var.image_id
  name  = var.identifier

  # entrypoint = []

  must_run    = var.enabled
  start       = var.enabled
  restart     = "always"
  stop_signal = "SIGINT"
  # wait   = true

  # shm_size = 256 # MB

  env = local.settings

  hostname = var.identifier

  networks_advanced {
    name = var.network_id
  }

  ports {
    internal = 9000
    external = var.port
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  volumes {
    container_path = local.container_data_directory
    host_path      = local.host_data_directory
    read_only      = false
  }

  volumes {
    container_path = local.container_extensions_directory
    host_path      = local.host_extensions_directory
    read_only      = false
  }

  volumes {
    container_path = local.container_logs_directory
    host_path      = local.host_logs_directory
    read_only      = false
  }

  volumes {
    container_path = local.container_temp_directory
    host_path      = local.host_temp_directory
    read_only      = false
  }
}
