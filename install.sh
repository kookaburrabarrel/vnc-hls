#!/bin/bash
set -euo pipefail

INSTALL_DIR="/home/user/vnc-hls"
NGINX_CONF="/etc/nginx/sites-available/vnc-hls"
SYSTEMD_DIR="/etc/systemd/system"

echo "Installing dependencies..."
apt update
apt install -y nginx python3 python3-pip

echo "Enabling NGINX and removing default site..."
systemctl enable nginx
rm -f /etc/nginx/sites-enabled/default

echo "Creating NGINX config for vnc-hls..."
cat > "$NGINX_CONF" <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        root $INSTALL_DIR;
        index index.html;
    }
}
EOF

ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/vnc-hls
nginx -t && systemctl reload nginx

echo "Creating systemd service for vnc-to-hls.sh..."
cat > "$SYSTEMD_DIR/vnc-to-hls.service" <<EOF
[Unit]
Description=VNC to HLS Streamer
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash $INSTALL_DIR/vnc-to-hls.sh
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=user

[Install]
WantedBy=multi-user.target
EOF

echo "Creating systemd service for archive.py..."
cat > "$SYSTEMD_DIR/archive.service" <<EOF
[Unit]
Description=Archive HLS Segments
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $INSTALL_DIR/archive.py
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=user

[Install]
WantedBy=multi-user.target
EOF

echo "Creating systemd service for archive_status.py..."
cat > "$SYSTEMD_DIR/archive-status.service" <<EOF
[Unit]
Description=Archive Status Generator
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $INSTALL_DIR/archive_status.py
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=user

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling services..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable vnc-to-hls.service
systemctl enable archive.service
systemctl enable archive-status.service

echo "Setting up hourly cron job for cleanup.sh..."
CRON_JOB="0 * * * * /bin/bash $INSTALL_DIR/cleanup.sh >> $INSTALL_DIR/logs/cleanup.log 2>&1"
( crontab -u user -l 2>/dev/null | grep -v 'cleanup.sh'; echo "$CRON_JOB" ) | crontab -u user -

echo "Setup complete. You can now start the services with:"
echo "  sudo systemctl start vnc-to-hls archive archive-status"
