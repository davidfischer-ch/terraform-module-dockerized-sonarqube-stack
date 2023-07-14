resource "docker_image" "app" {
  name         = var.app_image_name
  keep_locally = true # Prevent conflicts if other modules are using the image we are destroying
}

module "app" {
  source = "./sonarqube"

  identifier     = "${var.identifier}-app"
  enabled        = var.enabled
  image_id       = docker_image.app.image_id
  data_directory = "${var.data_directory}/app"

  # Networking

  network_id = docker_network.app.id
  port       = var.http_port

  # SonarQube Application

  settings = {}

  database_host     = module.database.host
  database_port     = module.database.port
  database_name     = module.database.name
  database_user     = module.database.user
  database_password = module.database.password
}
