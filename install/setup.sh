#!/bin/bash
set -euo pipefail

INSTALL_DIR="/home/user/vnc-hls"
SYSTEMD_DIR="/etc/systemd/system"
NGINX_CONF="/etc/nginx/sites-available/vnc-hls"
USER_NAME="user"

echo "=== Updating APT and installing required packages ==="
apt update
apt install -y \
  ffmpeg \
  libva-drm2 libva-x11-2 vainfo \
  tigervnc-standalone-server \
  x11vnc \
  xvfb \
  xauth \
  x11-utils \
  jq \
  curl \
  coreutils \
  procps \
  psmisc \
  net-tools \
  cron \
  python3 \
  python3-pip \
  nginx \
  php

echo "=== Installing Python dependencies ==="
/usr/bin/python3 -m pip install --upgrade pip
/usr/bin/python3 -m pip install flask requests

echo "=== Enabling and configuring NGINX ==="
systemctl enable nginx
rm -f /etc/nginx/sites-enabled/default

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

echo "=== Creating directories ==="
mkdir -p "$INSTALL_DIR"/{logs,hls,status}

echo "=== Creating systemd service for vnc-to-hls.sh ==="
cat > "$SYSTEMD_DIR/vnc-to-hls.service" <<EOF
[Unit]
Description=VNC to HLS Streamer
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash $INSTALL_DIR/vnc-to-hls.sh
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=$USER_NAME

[Install]
WantedBy=multi-user.target
EOF

echo "=== Creating systemd service for archive.py ==="
cat > "$SYSTEMD_DIR/archive.service" <<EOF
[Unit]
Description=Archive HLS Segments
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $INSTALL_DIR/archive.py
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=$USER_NAME

[Install]
WantedBy=multi-user.target
EOF

echo "=== Creating systemd service for archive_status.py ==="
cat > "$SYSTEMD_DIR/archive-status.service" <<EOF
[Unit]
Description=Archive Status Generator
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $INSTALL_DIR/archive_status.py
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=$USER_NAME

[Install]
WantedBy=multi-user.target
EOF

echo "=== Enabling systemd services ==="
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable vnc-to-hls.service
systemctl enable archive.service
systemctl enable archive-status.service

echo "=== Adding cleanup cron job ==="
CRON_JOB="0 * * * * /bin/bash $INSTALL_DIR/cleanup.sh >> $INSTALL_DIR/logs/cleanup.log 2>&1"
( crontab -u "$USER_NAME" -l 2>/dev/null | grep -v 'cleanup.sh'; echo "$CRON_JOB" ) | crontab -u "$USER_NAME" -

echo "=== Setup Complete ==="
echo "Start services with:"
echo "  sudo systemctl start vnc-to-hls archive archive-status"
