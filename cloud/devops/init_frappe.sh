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

# Optional: leave this if you want to export NGINX configs for external NGINX to use
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
# DONE
# ------------------
echo ""
echo "✅ Frappe setup complete!"
echo "🌐 Expose http://$SITE_NAME through your external NGINX reverse proxy."