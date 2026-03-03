# SonarQube Stack Terraform Module (Dockerized)

Manage SonarQube application's stack.

## Architecture

The module creates three interconnected components on a dedicated bridge network:

* **app** — SonarQube application (port 9000 internally), via the `sonarqube` sub-module.
* **database** — PostgreSQL backend, via the `postgresql` sub-module.
* **reverse-proxy** — Nginx reverse proxy with SSL termination, via the `nginx` sub-module.

> **Prerequisite:** The host must have `vm.max_map_count=262144` set: `sudo sysctl -w vm.max_map_count=262144`

## Usage

```hcl
module "sonarqube" {
  source = "git::https://github.com/davidfischer-ch/terraform-module-dockerized-sonarqube-stack.git?ref=main"

  identifier     = "sonarqube"
  enabled        = true
  data_directory = "/data/sonarqube"

  # Networking

  https_port = 10443
  http_port  = 10080

  # Reverse Proxy

  ssl_crt       = module.fisch3r_net.crt
  ssl_key       = module.fisch3r_net.key
  max_body_size = "20M"

  # SonarQube Application

  debug    = false
  domains  = ["sonarqube.example.com"]
  settings = {}

  # Images

  app_image_name        = "sonarqube:9.9.1-community"
  nginx_image_name      = "nginx:1.25.1"
  postgresql_image_name = "postgres:15.3"
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
| `enabled` | `bool` | — | Start or stop the containers. |
| `data_directory` | `string` | — | Host path for persistent volumes. |
| `hosts` | `map(string)` | `{}` | Extra `/etc/hosts` entries for the containers. |
| `https_port` | `number` | — | Reverse proxy HTTPS port. |
| `http_port` | `number` | — | Reverse proxy HTTP port. |
| `dhparam_use_dsa` | `bool` | `false` | Use DSA instead of DH params (faster but weaker). |
| `ssl_crt` | `string` | — | SSL certificate. |
| `ssl_key` | `string` | — | SSL private key. |
| `max_body_size` | `string` | `"20M"` | Nginx max body size. |
| `settings` | `map(string)` | `{}` | Additional environment variables for SonarQube. |
| `debug` | `bool` | — | Enable debug mode. |
| `domains` | `list(string)` | — | Domains for the reverse proxy. |
| `app_image_name` | `string` | — | [SonarQube](https://hub.docker.com/_/sonarqube/tags) Docker image name. |
| `nginx_image_name` | `string` | `"nginx:latest"` | [Nginx](https://hub.docker.com/_/nginx/tags) Docker image name. |
| `postgresql_image_name` | `string` | `"postgres:latest"` | [PostgreSQL](https://hub.docker.com/_/postgres/tags) Docker image name. |
| `postgresql_max_connections` | `number` | `100` | PostgreSQL `max_connections`. |
| `nginx_log_level` | `string` | `"warn"` | Nginx error log level. |
| `nginx_modules` | `list(string)` | `[]` | Nginx modules to load. |

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
