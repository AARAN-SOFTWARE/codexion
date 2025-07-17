#!/bin/bash

set -e

# Configuration
FRAPPE_BRANCH="develop"
SITE_NAME="site1.com"
ADMIN_PASS="admin"
DB_USER="root"
DB_PASS="DbPass1@@"
DB_HOST="mariadb"
BENCH_DIR="/home/devops/frappe-bench"
SUPERVISOR_CONF="/etc/supervisor/conf.d/frappe.conf"
NGINX_CONF="/etc/nginx/sites-enabled/frappe.conf"

echo "🌀 Installing Frappe Bench..."
cd /home/devops
bench init frappe-bench --frappe-branch $FRAPPE_BRANCH
cd $BENCH_DIR

echo "🌐 Creating site: $SITE_NAME"
bench new-site "$SITE_NAME" \
  --admin-password "$ADMIN_PASS" \
  --mariadb-root-username "$DB_USER" \
  --mariadb-root-password "$DB_PASS" \
  --db-host "$DB_HOST" \
  --no-mariadb-socket

bench use "$SITE_NAME"
bench get-app --branch "$FRAPPE_BRANCH" erpnext https://github.com/frappe/erpnext
bench --site "$SITE_NAME" install-app erpnext

echo "🔗 Linking ports and building assets..."
bench build --force
bench set-config -g developer_mode 1
bench set-config -g host_name http://0.0.0.0:8000
bench set-nginx-port "$SITE_NAME" 8000
bench setup nginx

echo "🧩 Setting up Supervisor config..."
cat <<EOF | sudo tee "$SUPERVISOR_CONF"
[program:frappe]
command=/bin/bash -c "cd $BENCH_DIR && bench start"
directory=$BENCH_DIR
autostart=true
autorestart=true
stdout_logfile=/home/devops/logs/bench.log
stderr_logfile=/home/devops/logs/bench.err.log
user=devops
EOF

sudo mkdir -p /home/devops/logs

echo "🔁 Restarting Supervisor..."
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start frappe

echo "🌐 Setting up NGINX for port 8000..."
sudo tee "$NGINX_CONF" > /dev/null <<EOF
server {
    listen 80;
    server_name $SITE_NAME;

    location / {
        proxy_pass http://0.0.0.0:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

sudo nginx -s reload

echo "✅ Setup Complete. Access your site at: http://localhost or http://<host-ip>"
