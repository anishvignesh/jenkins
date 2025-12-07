#!/usr/bin/env bash
set -eo pipefail

HEALTH_URL="${1:-http://localhost/}"
MAX_RETRIES="${2:-3}"
SLEEP_TIME="${3:-5}"

log() { echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*"; }

check_health() {
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" || echo "000")
    if [[ "$http_code" == 2* || "$http_code" == 3* ]]; then
        log "HEALTH OK (HTTP $http_code)"
        return 0
    else
        log "HEALTH FAIL (HTTP $http_code)"
        return 1
    fi
}

restart_nginx() {
    log "Restarting nginx..."
    sudo systemctl restart nginx || sudo service nginx restart || true
    sleep 2
}

### First check
if check_health; then
    exit 0
fi

retry=0
while [[ $retry -lt $MAX_RETRIES ]]; do
    retry=$((retry+1))
    log "Retry $retry/$MAX_RETRIES..."
    restart_nginx
    sleep "$SLEEP_TIME"

    if check_health; then
        log "Nginx is restored."
        exit 0
    fi
done

log "NGINX STILL DOWN after all retries!"
exit 1
