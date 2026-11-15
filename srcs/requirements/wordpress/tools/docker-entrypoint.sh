#!/bin/sh
set -e

mkdir -p /var/www/wordpress
cd /var/www/wordpress

echo "Waiting for MariaDB service on port 3306..."
until mariadb-admin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    sleep 2
done

echo "MariaDB is reachable! Starting WordPress setup..."

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --path=/var/www/wordpress --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --path=/var/www/wordpress \
        --allow-root

    echo "Installing WordPress core..."
    wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --path=/var/www/wordpress \
        --allow-root

    echo "Creating author user..."
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --path=/var/www/wordpress \
        --allow-root

    chown -R www-data:www-data /var/www/wordpress
    echo "WordPress setup complete!"
fi

echo "Starting PHP-FPM..."
exec "$@"
