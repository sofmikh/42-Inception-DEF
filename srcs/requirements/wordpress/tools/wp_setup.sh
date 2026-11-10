#!/bin/bash
# =============================================================
# WordPress initialization script
#
# Flow:
# 1. Wait for MariaDB to be ready (it starts in parallel)
# 2. Download WordPress core files using WP-CLI
# 3. Generate wp-config.php with database credentials
# 4. Run WordPress installation (creates DB tables, sets up admin)
# 5. Create the secondary user (author role)
# 6. Start PHP-FPM in the foreground
#
# On subsequent starts (wp-config.php already exists),
# steps 1-5 are skipped and PHP-FPM starts immediately.
# =============================================================
set -e

cd /var/www/html

echo "[WordPress] Checking installation status..."

# Only run the full setup on the very first start
# wp-config.php is created during setup and persisted via volume
if [ ! -f "/var/www/html/wp-config.php" ]; then

    echo "[WordPress] First run: installing WordPress..."

    # Wait for MariaDB to accept connections before proceeding
    # MariaDB and WordPress containers start in parallel
    echo "[WordPress] Waiting for MariaDB..."
    while ! mysqladmin ping -h mariadb -u "${DB_USER}" -p"${DB_PASSWORD}" --silent 2>/dev/null; do
        sleep 2
    done
    echo "[WordPress] MariaDB is ready!"

    # Download WordPress core files only if they do not already exist
    if [ ! -f "/var/www/html/wp-login.php" ]; then
        echo "[WordPress] Downloading WordPress..."
        wp core download --allow-root
    fi

    # Create wp-config.php with the database connection details
    # dbhost "mariadb" is the service name in docker-compose
    # Docker's internal DNS resolves "mariadb" to the container's IP
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root \
        --force

    # Run the WordPress installation:
    # - Creates all required database tables
    # - Sets the site URL, title and admin credentials
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    # Create a second user with the "author" role
    # The correction requires at least one non-admin WordPress user
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

    # Update the default Sample Page with the opening of The Little Prince
    wp post update 2 \
        --post_title="The Little Prince" \
        --post_content="Once when I was six years old I saw a magnificent picture in a book, called True Stories from Nature, about the primeval forest. It was a picture of a boa constrictor in the act of swallowing an animal. Here is a copy of the drawing." \
        --allow-root

    echo "[WordPress] Installation complete."
else
    echo "[WordPress] Already installed, skipping setup."
fi

echo "[WordPress] Starting PHP-FPM 8.2 in foreground..."
# exec replaces this script with php-fpm as PID 1 of the container
# -F flag: run in foreground (no daemon mode)
# This is required by Docker: PID 1 must stay alive
exec /usr/sbin/php-fpm8.2 -F
