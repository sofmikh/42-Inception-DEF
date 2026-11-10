#!/bin/bash
# =============================================================
# NGINX startup script
#
# Flow:
# 1. Generate a self-signed TLS certificate if it doesn't exist
# 2. Start NGINX in the foreground
#
# The certificate is self-signed because we don't have a real
# domain registered with a CA. Browsers will show a security
# warning, which is expected and acceptable for this project.
# =============================================================
set -e

CERT=/etc/ssl/certs/inception.crt
KEY=/etc/ssl/private/inception.key

# Generate a self-signed certificate only if it doesn't already exist
if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
    echo "[NGINX] Generating self-signed TLS certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/C=ES/ST=Madrid/L=Madrid/O=42Madrid/OU=Inception/CN=${DOMAIN_NAME}"
    echo "[NGINX] Certificate generated at: $CERT"
fi

echo "[NGINX] Starting NGINX in foreground..."
# "daemon off" prevents NGINX from forking into the background
# Without this, NGINX would daemonize, the script would exit,
# and Docker would think the container has stopped
exec nginx -g "daemon off;"
