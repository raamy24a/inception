#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql > /dev/null

    tfile=$(mktemp)
    cat << EOF > "$tfile"
USE mysql;
FLUSH PRIVILEGES;

-- Set root password securely
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');

-- Create database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create user with access from any host (%)
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

FLUSH PRIVILEGES;
EOF

    /usr/sbin/mysqld --user=mysql --bootstrap < "$tfile"
    rm -f "$tfile"
    echo "Database initialized successfully."
fi

exec /usr/sbin/mysqld --user=mysql --console
