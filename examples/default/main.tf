resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "acme_registration" "main" {
  email_address = "admin@example.com"
}

resource "acme_certificate" "sonarqube" {
  account_key_pem = acme_registration.main.account_key_pem
  common_name     = "sonarqube.example.com"

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = aws_route53_zone.main.zone_id
    }
  }
}

module "sonarqube" {
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-sonarqube-stack.git?ref=1.3.0"

  identifier = "sonarqube"

  # Process

  app_image_name = "sonarqube:9.9.6-community" # https://hub.docker.com/_/sonarqube/tags

  # Networking

  https_port = 10443
  http_port  = 10080

  # Reverse Proxy

  ssl_crt = join("", [
    acme_certificate.sonarqube.certificate_pem,
    acme_certificate.sonarqube.issuer_pem
  ])
  ssl_key = acme_certificate.sonarqube.private_key_pem

  # Storage

  data_directory = "/data/sonarqube"

  # SonarQube Application

  domains = ["sonarqube.example.com"]

  # Database Container

  postgresql_image_name = "postgres:15.10" # https://hub.docker.com/_/postgres/tags

  # Reverse Proxy Container

  nginx_image_name = "nginx:1.28.0" # https://hub.docker.com/_/nginx/tags
}
