# SonarQube Stack Terraform Module (Dockerized)

Manage SonarQube application's stack.

## Example

Example:

```
module "sonarqube_dev" {
  source = "git::ssh://git@gitlab.fisch3r.net:10022/family/infrastructure/modules/terraform-module-dockerized-sonarqube-stack.git?ref=main"

  identifier     = "sonarqube-dev"
  enabled        = true
  data_directory = "/data/sonarqube-dev"

  # Networking

  http_port = 10080

  # SonarQube Application

  settings = {}

  app_image_name        = "sonarqube:9.9.1-community" # https://hub.docker.com/_/sonarqube/tags
  postgresql_image_name = "postgres:15.3"             # https://hub.docker.com/_/postgres/tags
}
```
