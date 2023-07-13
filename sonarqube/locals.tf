locals {
  # Following directories are explicitly declared as environment variables
  # https://github.com/SonarSource/docker-sonarqube/blob/master/10/community/Dockerfile
  container_data_directory       = "/opt/sonarqube/data"
  container_extensions_directory = "/opt/sonarqube/extensions"
  container_logs_directory       = "/opt/sonarqube/logs"
  container_temp_directory       = "/opt/sonarqube/temp"

  host_data_directory       = "${var.data_directory}/data"
  host_extensions_directory = "${var.data_directory}/extensions"
  host_logs_directory       = "${var.data_directory}/logs"
  host_temp_directory       = "${var.data_directory}/temp"

  settings = merge(var.settings, local.forced_settings)

  forced_settings = {
    SQ_DATA_DIR       = local.container_data_directory,
    SQ_EXTENSIONS_DIR = local.container_extensions_directory,
    SQ_LOGS_DIR       = local.container_logs_directory,
    SQ_TEMP_DIR       = local.container_temp_directory
  }
}
