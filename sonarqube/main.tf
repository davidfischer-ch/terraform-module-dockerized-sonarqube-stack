resource "docker_container" "server" {

  # TODO Handle multiple application nodes

  image = var.image_id
  name  = var.identifier

  # Wrapper entrypoint applies ES cluster settings via the API at startup, then execs the
  # real SonarQube entrypoint. Only when es_cluster_settings is set; otherwise image default.
  entrypoint = length(var.es_cluster_settings) > 0 ? ["${local.container_config_directory}/es-entrypoint.sh"] : null

  must_run    = var.enabled
  start       = var.enabled
  restart     = "always"
  stop_signal = "SIGINT"
  # wait   = true

  # shm_size = 256 # MB

  env = toset(concat(
    [for k, v in local.settings : "${k}=${v}"],
    length(var.es_cluster_settings) > 0
    ? ["SONARQUBE_ES_CLUSTER_SETTINGS=${jsonencode({ persistent = var.es_cluster_settings })}"]
    : []
  ))

  dynamic "host" {
    for_each = var.hosts
    content {
      host = host.key
      ip   = host.value
    }
  }

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

  dynamic "volumes" {
    for_each = length(var.es_cluster_settings) > 0 ? [1] : []
    content {
      container_path = "${local.container_config_directory}/es-entrypoint.sh"
      host_path      = local_file.es_entrypoint[0].filename
      read_only      = true
    }
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
