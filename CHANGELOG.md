# Changelog

## Release v1.3.0 (2026-04-28)

### Minor compatibility breaks

* Upgrade nginx-templates to 1.1.0; internal nginx now requires TLS 1.2+ and AEAD-only ciphers (see nginx-templates CHANGELOG for full details)

## Release v1.2.0 (2026-04-28)

### Minor compatibility breaks

* Bump minimum `NikolaLohinski/jinja` provider version from `1.17.0` to `2.0.0`. Consumers must run `terraform init -upgrade` to refresh the provider.

### Fix and enhancements

* Upgrade nginx to 1.3.0

## Release v1.1.2 (2026-03-13)

### Fix and enhancements

* Upgrade `nginx` module to 1.2.0

## Release v1.1.1 (2026-03-13)

### Fix and enhancements

* Upgrade `nginx` module to 1.1.3
* Upgrade `postgresql` module to 1.2.2
* Add `debug` missing default to `false`
* Set `enabled` and `wait` defaults to `true`
* Refine variable descriptions, validators, and attribute ordering
* Remove redundant default values from examples and README

## Release v1.1.0 (2026-03-13)

### Features

* Add variable `wait` (default to `false`)
* Add `nginx_uid`/`nginx_gid` process identity variables for the reverse proxy (default `0`)
* Add `postgresql_uid`/`postgresql_gid` process identity variables for the database (default `999`/`0`)
* Automatically adds `NET_BIND_SERVICE` capability to nginx container if `uid` is not root (required for ports binding)

### Fix and enhancements

* Update README and example

## Release v1.0.4 (2026-03-13)

### Fix and enhancements

* Upgrade `nginx` module to v1.1.2

## Release v1.0.3 (2026-01-03)

### Fix and enhancements

* Module: Declare network_mode bridge to prevent infinite recreate

## Release v1.0.2 (2025-06-11)

### Features

* Add variable `dhparam_use_dsa` (default to `false`)

### Fix and enhancements

* Upgrade `nginx` module version 1.0.2

## Release v1.0.1 (2025-06-11)

### Fix and enhancements

* Update modules URLs

## Release v1.0.0 (2025-01-20)

Initial release
