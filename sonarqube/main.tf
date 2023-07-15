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

  env = toset([for k, v in local.settings : "${k}=\"${v}\""])

  hostname = var.identifier

  networks_advanced {
    name = var.network_id
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

  provisioner "local-exec" {
    command = <<EOT
      chmod 777 "${local.host_data_directory}"
      chmod 777 "${local.host_extensions_directory}"
      chmod 777 "${local.host_logs_directory}"
      chmod 777 "${local.host_temp_directory}"
    EOT
  }
}
