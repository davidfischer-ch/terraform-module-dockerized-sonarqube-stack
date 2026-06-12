resource "local_file" "es_entrypoint" {
  count                = length(var.es_cluster_settings) > 0 ? 1 : 0
  filename             = "${local.host_config_directory}/es-entrypoint.sh"
  content              = file("${path.module}/config/es-entrypoint.sh")
  file_permission      = "0755"
  directory_permission = "0755"
}
