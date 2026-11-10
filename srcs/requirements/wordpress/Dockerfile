# Base image: Debian 12 Bookworm (penultimate stable as of 2026)
FROM debian:bookworm

# Install PHP 8.2 FPM and all extensions required by WordPress
# - php8.2-fpm: FastCGI Process Manager, runs PHP without a web server
# - php8.2-mysql: allows PHP to connect to MariaDB
# - php8.2-curl/gd/mbstring/xml/zip: required by WordPress core and plugins
# - default-mysql-client: provides mysqladmin for the health check in the script
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    wget \
    curl \
    less \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI: command-line tool for managing WordPress
# Used in the setup script to download and configure WordPress without a browser
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy the PHP-FPM pool configuration
# Configures PHP-FPM to listen on 0.0.0.0:9000 (all interfaces)
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy the WordPress setup script and make it executable
COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh
RUN chmod +x /usr/local/bin/wp_setup.sh

# Create the web root directory with correct ownership
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Expose the PHP-FPM port (FastCGI protocol, internal to Docker network)
# NGINX connects to this port to execute PHP files
EXPOSE 9000

# Run the WordPress setup script as the container entrypoint
ENTRYPOINT ["wp_setup.sh"]
