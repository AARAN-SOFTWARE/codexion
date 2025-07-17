# to init docker

```
./cloud/install.sh
```

# From host

```
docker exec -it codexion-cloud bash
```

#### host backend server from

> **root@9fa144a9ee4c:/workspace : ./setup/int.sh **

```
 ./setup/init.sh
```

enter 1 to start server


Here's a **complete `install_frappe.sh` script** that:

✅ Installs `frappe-bench`
✅ Creates a new Frappe site
✅ Sets up Supervisor to run `bench start`
✅ Creates a basic NGINX config
✅ Binds Frappe on `0.0.0.0:8000` to be reachable outside the container

---

### ✅ Prerequisites:

Make sure you already have:

* Python 3.11+ installed
* `node`, `npm`, `yarn`
* Redis, MariaDB services running
* Docker network configured if using containers
* `/home/devops/frappe-bench` as your bench directory

---

### 📜 `install_frappe.sh`

```bash
#!/bin/bash

set -e

# Configuration
FRAPPE_BRANCH="develop"
SITE_NAME="site1.com"
ADMIN_PASS="admin"
DB_PASS="DbPass1@"
DB_HOST="mariadb"
BENCH_DIR="/home/devops/frappe-bench"
SUPERVISOR_CONF="/etc/supervisor/conf.d/frappe.conf"
NGINX_CONF="/etc/nginx/sites-enabled/frappe.conf"

echo "🌀 Installing Frappe Bench..."
cd /home/devops
bench init frappe-bench --frappe-branch $FRAPPE_BRANCH
cd $BENCH_DIR

echo "🌐 Creating site: $SITE_NAME"
bench new-site $SITE_NAME \
  --admin-password $ADMIN_PASS \
  --mariadb-root-password "$DB_PASS" \
  --db-host $DB_HOST

bench use $SITE_NAME
bench get-app --branch $FRAPPE_BRANCH erpnext https://github.com/frappe/erpnext
bench --site $SITE_NAME install-app erpnext

echo "🔗 Linking ports and building assets..."
bench build
bench build --force
bench set-config -g developer_mode 1
bench set-config -g host_name http://0.0.0.0:8000
bench set-nginx-port $SITE_NAME 8000
bench setup nginx

echo "🧩 Setting up Supervisor config..."
cat <<EOF | sudo tee $SUPERVISOR_CONF
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
sudo tee $NGINX_CONF > /dev/null <<EOF
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
```

---

### 🧪 To Run This:

1. Make script executable:

   ```bash
   chmod +x install_frappe.sh
   ```

2. Run as `root` or use `sudo`:

   ```bash
   ./install_frappe.sh
   ```

---

### 🌐 Exposing Port Outside Container (if Docker)

If this is running inside Docker, **make sure your container is started with**:

```bash
docker run -p 8000:8000 -p 80:80 codexion-cloud
```

Or expose ports in `docker-compose.yml`:

```yaml
ports:
  - "8000:8000"
  - "80:80"
```

---

Would you like to also include optional `sites.txt` support or create multiple sites automatically from a `.env` or list?


✅ 2. Clear Git Bash Command History Temporarily
This clears your in-session command history:

bash
Copy
Edit
history -c
⚠️ This doesn't remove what's already saved in the .bash_history file until you log out or clear it manually.


Run:

bash
Copy
Edit
chmod +x ./install.sh
Then run it:

bash
Copy
Edit
./install.sh


cloudcmd --port 9001