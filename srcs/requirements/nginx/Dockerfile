# Base image: Debian 12 Bookworm (penultimate stable as of 2026)
FROM debian:bookworm

# Install NGINX (web server / reverse proxy) and OpenSSL (for TLS certificate generation)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy our custom NGINX virtual host configuration
# This replaces the default site config
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Copy the startup script (generates the SSL certificate, then starts NGINX)
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Only expose port 443 (HTTPS)
# Port 80 (HTTP) is intentionally NOT exposed - the subject requires HTTPS only
EXPOSE 443

# Run the setup script as the container entrypoint
ENTRYPOINT ["setup.sh"]
