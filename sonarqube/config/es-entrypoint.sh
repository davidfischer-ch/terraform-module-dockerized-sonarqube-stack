#!/bin/bash
# Apply Elasticsearch cluster settings (read from $SONARQUBE_ES_CLUSTER_SETTINGS) once the
# embedded ES is up, then hand off to the real SonarQube entrypoint. The embedded ES
# ignores -Des.* JVM properties, so cluster settings (e.g. disk watermarks) must go through
# the cluster-settings API. The image ships no curl/wget, so we speak raw HTTP over
# /dev/tcp. The applier is backgrounded and best-effort: it never blocks SonarQube startup.
set -e

if [ -n "${SONARQUBE_ES_CLUSTER_SETTINGS:-}" ]; then
  (
    body="$SONARQUBE_ES_CLUSTER_SETTINGS"
    # Wait for the ES HTTP port to accept connections (max ~120s).
    for _ in $(seq 1 60); do
      (exec 3<>/dev/tcp/127.0.0.1/9001) 2>/dev/null && break
      sleep 2
    done
    exec 3<>/dev/tcp/127.0.0.1/9001
    printf 'PUT /_cluster/settings HTTP/1.1\r\nHost: localhost\r\nContent-Type: application/json\r\nContent-Length: %d\r\nConnection: close\r\n\r\n%s' \
      "${#body}" "$body" >&3
    cat <&3
  ) >/opt/sonarqube/logs/es-settings-apply.log 2>&1 &
fi

exec /opt/sonarqube/docker/entrypoint.sh "$@"
