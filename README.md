# SonarQube Stack Terraform Module (Dockerized)

Manage SonarQube application's stack.

## Architecture

The module creates three interconnected components on a dedicated bridge network:

* **app** — SonarQube application (port 9000 internally), via the `sonarqube` sub-module.
* **database** — PostgreSQL backend, via the `postgresql` sub-module.
* **reverse-proxy** — Nginx reverse proxy with SSL termination, via the `nginx` sub-module.

> **Prerequisite:** The host must have `vm.max_map_count=262144` set: `sudo sysctl -w vm.max_map_count=262144`

## Usage

See [examples/default](examples/default) for a complete working configuration.

```hcl
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

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
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-sonarqube-stack.git?ref=1.1.1"

  identifier     = "sonarqube"
  data_directory = "/data/sonarqube"

  # Networking

  https_port = 10443
  http_port  = 10080

  # Reverse Proxy

  ssl_crt = join("", [acme_certificate.sonarqube.certificate_pem, acme_certificate.sonarqube.issuer_pem])
  ssl_key = acme_certificate.sonarqube.private_key_pem

  # SonarQube Application

  domains = ["sonarqube.example.com"]

  # Images

  app_image_name        = "sonarqube:9.9.6-community" # https://hub.docker.com/_/sonarqube/tags
  nginx_image_name      = "nginx:1.28.0"              # https://hub.docker.com/_/nginx/tags
  postgresql_image_name = "postgres:15.10"            # https://hub.docker.com/_/postgres/tags
}
```

## Data layout

All persistent data lives under `data_directory`:

```
data_directory/
├── app/
│   ├── data/        # SonarQube data files
│   ├── extensions/  # SonarQube plugins
│   ├── logs/        # SonarQube logs
│   └── temp/        # SonarQube temporary files
├── database/
│   └── data/        # PostgreSQL data files
└── reverse-proxy/
    └── ...          # Nginx configuration and certificates
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `identifier` | `string` | — | Unique name for resources (must match `^[a-z]+(-[a-z0-9]+)*$`). |
| `enabled` | `bool` | `true` | Start or stop the containers. |
| `wait` | `bool` | `true` | Wait for containers to reach a healthy state after creation (applies to Nginx and PostgreSQL). |
| `data_directory` | `string` | — | Host path for persistent volumes. |
| `hosts` | `map(string)` | `{}` | Extra `/etc/hosts` entries for the containers. |
| `https_port` | `number` | — | Reverse proxy HTTPS port. |
| `http_port` | `number` | — | Reverse proxy HTTP port. |
| `dhparam_use_dsa` | `bool` | `false` | Use DSA instead of DH params (faster but weaker). |
| `ssl_crt` | `string` | — | SSL certificate. |
| `ssl_key` | `string` | — | SSL private key. |
| `max_body_size` | `string` | `"20M"` | Nginx max body size. |
| `settings` | `map(string)` | `{}` | Additional environment variables for SonarQube. |
| `debug` | `bool` | `false` | Enable debug mode. |
| `domains` | `list(string)` | — | Domains for the reverse proxy. |
| `app_image_name` | `string` | — | [SonarQube](https://hub.docker.com/_/sonarqube/tags) Docker image name. |
| `nginx_image_name` | `string` | `"nginx:latest"` | [Nginx](https://hub.docker.com/_/nginx/tags) Docker image name. |
| `nginx_uid` | `number` | `0` | UID of the user running the reverse-proxy container. |
| `nginx_gid` | `number` | `0` | GID of the user running the reverse-proxy container. |
| `nginx_log_level` | `string` | `"warn"` | Nginx error log level. |
| `nginx_modules` | `list(string)` | `[]` | Nginx modules to load. |
| `postgresql_image_name` | `string` | `"postgres:latest"` | [PostgreSQL](https://hub.docker.com/_/postgres/tags) Docker image name. |
| `postgresql_uid` | `number` | `999` | UID of the user running the database container. |
| `postgresql_gid` | `number` | `0` | GID of the user running the database container. |
| `postgresql_max_connections` | `number` | `100` | PostgreSQL `max_connections`. |

## Requirements

* Terraform >= 1.6
* [kreuzwerker/docker](https://github.com/kreuzwerker/terraform-provider-docker) >= 3.0.2
* [NikolaLohinski/jinja](https://github.com/NikolaLohinski/terraform-provider-jinja) >= 1.17.0
* [hashicorp/local](https://github.com/hashicorp/terraform-provider-local) >= 2.4.1
* [hashicorp/null](https://github.com/hashicorp/terraform-provider-null) >= 3.2.2
* [hashicorp/random](https://github.com/hashicorp/terraform-provider-random) >= 3.6.0

## References

* https://hub.docker.com/_/sonarqube
* https://github.com/SonarSource/docker-sonarqube
* https://hub.docker.com/_/postgres
