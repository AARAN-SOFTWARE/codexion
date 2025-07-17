#!/bin/bash
set -e

# ✅ Hardcoded values (edit these as needed)
MARIADB_HOST="localhost"
MARIADB_ROOT_PASSWORD="DbPass1@@"

# ✅ Install mariadb-client
echo "📦 Installing mariadb-client..."
sudo apt update && sudo apt install -y mariadb-client

# ✅ Ensure mariadb client is installed
if ! command -v mariadb &> /dev/null; then
    echo "❌ mariadb client not installed."
    exit 1
fi

# ✅ Update MariaDB config file
echo "⚙️ Updating MariaDB config at /etc/mysql/mariadb.conf.d/50-server.cnf..."

sudo bash -c "cat <<EOF > /etc/mysql/mariadb.conf.d/50-server.cnf
[server]
user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysqld.sock
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc-messages-dir = /usr/share/mysql
bind-address = 127.0.0.1
query_cache_size = 16M
log_error = /var/log/mysql/error.log

[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
EOF"

# ✅ Restart MariaDB to apply config
echo "🔄 Restarting MariaDB service..."
sudo systemctl restart mariadb

# ✅ Connect to MariaDB and grant remote access
echo "🔐 Connecting to MariaDB at $MARIADB_HOST and updating privileges..."

mariadb -h "$MYSQL_HOST" -uroot -p"$MARIADB_ROOT_PASSWORD" <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "✅ MariaDB configuration and privileges successfully updated."