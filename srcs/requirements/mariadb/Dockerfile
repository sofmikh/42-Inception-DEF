# Base image: Debian 12 Bookworm (penultimate stable as of 2026)
FROM debian:bookworm

# Install MariaDB server
# Clean apt cache afterwards to keep the image small
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copy our custom MariaDB configuration
# This sets bind-address=0.0.0.0 so WordPress can reach it from another container
COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/inception.cnf

# Copy the initialization script and make it executable
COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh

# Expose MySQL/MariaDB default port (internal network only, not published to host)
EXPOSE 3306

# Run the setup script as the container entrypoint
# The script will start MariaDB in the foreground (no daemon, no &)
ENTRYPOINT ["mariadb_setup.sh"]
