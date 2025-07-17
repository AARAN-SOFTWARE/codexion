#!/bin/bash

set -e

# ------------------
# CONFIGURATION
# ------------------
FRAPPE_BRANCH="develop"
SITE_NAME="site1.com"
ADMIN_PASS="admin"
DB_USER="root"
DB_PASS="DbPass1@@"
DB_HOST="mariadb"
BENCH_DIR="/home/devops/frappe-bench"
SUPERVISOR_CONF="/etc/supervisor/conf.d/frappe.conf"
NGINX_CONF="/etc/nginx/sites-enabled/frappe.conf"
EMAIL="admin@$SITE_NAME"

# ------------------
# INIT
# ------------------
echo "🌀 Installing Frappe Bench..."
cd /home/devops
bench init frappe-bench --frappe-branch "$FRAPPE_BRANCH"
cd "$BENCH_DIR"

echo "🌐 Creating site: $SITE_NAME"
bench new-site "$SITE_NAME" \
  --admin-password "$ADMIN_PASS" \
  --mariadb-root-username "$DB_USER" \
  --mariadb-root-password "$DB_PASS" \
  --db-host "$DB_HOST" \
  --no-mariadb-socket

bench use "$SITE_NAME"

# ------------------
# GET APPS
# ------------------
read -p "📦 Press any key to install ERPNext..." -n1 -s
echo ""
bench get-app --branch "$FRAPPE_BRANCH" erpnext https://github.com/frappe/erpnext
bench --site "$SITE_NAME" install-app erpnext

read -p "📦 Press any key to install CRM..." -n1 -s
echo ""
bench get-app --branch "$FRAPPE_BRANCH" crm https://github.com/frappe/crm
bench --site "$SITE_NAME" install-app crm

read -p "📦 Press any key to install HRMS..." -n1 -s
echo ""
bench get-app --branch "$FRAPPE_BRANCH" hrms https://github.com/frappe/hrms
bench --site "$SITE_NAME" install-app hrms

read -p "📦 Press any key to install India Compliance..." -n1 -s
echo ""
bench get-app --branch "$FRAPPE_BRANCH" india_compliance https://github.com/resilient-tech/india-compliance
bench --site "$SITE_NAME" install-app india_compliance

# ------------------
# BUILD & CONFIGURE
# ------------------
bench build --force
bench set-config -g developer_mode 1
bench set-config -g host_name http://0.0.0.0:8000
bench set-nginx-port "$SITE_NAME" 8000
bench setup nginx

# ------------------
# SUPERVISOR SETUP
# ------------------
echo "🧩 Setting up Supervisor config..."
sudo mkdir -p /home/devops/logs
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

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start frappe

# ------------------
# NGINX SETUP
# ------------------
echo "🌐 Setting up NGINX for http://$SITE_NAME"
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

# ------------------
# SSL CERTBOT
# ------------------
echo "🔒 Installing Certbot and configuring SSL for https://$SITE_NAME"
sudo apt-get update && sudo apt-get install -y certbot python3-certbot-nginx

sudo certbot --nginx \
  --non-interactive \
  --agree-tos \
  --redirect \
  --email "$EMAIL" \
  -d "$SITE_NAME"

# Auto-renewal setup (systemd or cron installed by default)
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
sudo certbot renew --dry-run

# ------------------
# DONE
# ------------------
echo ""
echo "✅ Setup Complete!"
echo "🔗 Access your site: https://$SITE_NAME"
echo "🛡️ SSL is enabled and auto-renewing"
