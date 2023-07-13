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

## References

Official's SonarQube [docker-compose.yml](https://github.com/SonarSource/docker-sonarqube/blob/master/example-compose-files/sq-with-postgres/docker-compose.yml) :

``` yaml
---
version: "3"
services:
  sonarqube:
    image: sonarqube:community
    hostname: sonarqube
    container_name: sonarqube
    depends_on:
      - db
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    ports:
      - "9000:9000"
  db:
    image: postgres:13
    hostname: postgresql
    container_name: postgresql
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql:
  postgresql_data:
...
```
