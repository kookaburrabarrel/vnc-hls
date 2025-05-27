  ethernets:
    enp1s0:
      dhcp4: no
      addresses: [192.168.1.11/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
EOF

sudo netplan apply
ip a
ls -l /home/user/vnc-hls/
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard 192.168.1.11;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files \$uri \$uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
sudo nginx -t
ls -ld /home/user/vnc-hls
ls -ld /home/user /home/user/vnc-hls
ls -l /home/user/vnc-hls/index.html
sudo tail -n 20 /var/log/nginx/error.log
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard 192.168.1.11;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files $uri $uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
echo "127.0.0.1 dashboard.internal" | sudo tee -a /etc/hosts
echo "192.168.1.11 dashboard.internal" | sudo tee -a /etc/hosts
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard.internal;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files $uri $uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
ls
cd vnc-hls
git status
git remote -v
git log --oneline -n 5
git diff ../vnc-to-hls.sh
git diff --name-status
git add -A
git commit -m "WIP: local changes and deletions from live run"
git push origin main
LS
ls
rm *.html
ls
cd vnc-hls
s
git restore index.html
ls
cd ..
ls
pw
pwd
ls
sudo nano /etc/systemd/system/vnc-to-hls.service
cat << 'EOF' | sudo tee /etc/systemd/system/vnc-to-hls.service > /dev/null
[Unit]
Description=VNC to HLS Transcoder
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=user
ExecStart=/home/user/vnc-to-hls.sh
Restart=always
RestartSec=5
Environment=DISPLAY=:0
Environment=XDG_RUNTIME_DIR=/run/user/1000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vnc-to-hls.service
sudo systemctl start vnc-to-hls.service
systemctl status vnc-to-hls.service
sudo reboot
systemctl status vnc-to-hls.service
sudo reboot
ls
vnc
sudo journalctl -u vnc-to-hls.service -f
ls
ffplay /home/user/vnc-hls/hls/lane1.m3u8
vncviewer 192.168.4.101:5900 -passwd /home/user/.vnc/passwd
vncviewer 192.168.4.101:5900
vncviewer 192.168.4.102:5900
ps aux | grep Xvfb
ls -l /home/user/.vnc/passwd
cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Start vncviewer and log output
vncviewer -ViewOnly=1 -Fullscreen=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > /tmp/vncviewer_lane1.log 2>&1 &

VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

kill $VNC_PID
kill $XVFB_PID
echo "[INFO] Log output from vncviewer:"
cat /tmp/vncviewer_lane1.log

EOF

./lane1-test.sh
#!/bin/bash
export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2
xauth generate :11 . trusted
# Start vncviewer and log output
vncviewer -ViewOnly=1 -Fullscreen=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > /tmp/vncviewer_lane1.log 2>&1 &
VNC_PID=$!
echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30
kill $VNC_PID
kill $XVFB_PID
echo "[INFO] Log output from vncviewer:"
cat /tmp/vncviewer_lane1.log
chmod +x lane1-test.sh
./lane1-test.sh
user@vnctranscoder:~$ chmod +x lane1-test.sh
./lane1-test.sh
(EE) 
Fatal server error:
(EE) Server is already active for display 11
	If this server is no longer running, remove /tmp/.X11-lock
	and start again.
(EE) 
xauth:  file  does not exist
xauth:  unable to rename authority file , use -n
[INFO] Xvfb PID: 
[INFO] vncviewer PID: 
[INFO] Waiting 30s to capture connection...
user@vnctranscoder:~$ chmod +x lane1-test.sh
./lane1-test.sh
(EE) 
Fatal server error:
(EE) Server is already active for display 11
	If this server is no longer running, remove /tmp/.X11-lock
	and start again.
(EE) 
xauth:  file  does not exist
xauth:  unable to rename authority file , use -n
[INFO] Xvfb PID: 
[INFO] vncviewer PID: 
[INFO] Waiting 30s to capture connection...
[200~pkill -f "Xvfb :11"
pkill -f "Xvfb :11"
pkill -f "vncviewer .*192.168.4.101"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Log output path
LOG_FILE="/tmp/vncviewer_lane1.log"

# Start vncviewer with logging
vncviewer -ViewOnly=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > "$LOG_FILE" 2>&1 &
VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

# Cleanup
kill $VNC_PID
kill $XVFB_PID
rm -f "$XAUTH_FILE"

echo "[INFO] Log output from vncviewer:"
cat "$LOG_FILE"

EOF

cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Log output path
LOG_FILE="/tmp/vncviewer_lane1.log"

# Start vncviewer with logging
vncviewer -ViewOnly=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > "$LOG_FILE" 2>&1 &
VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

# Cleanup
kill $VNC_PID
kill $XVFB_PID
rm -f "$XAUTH_FILE"

echo "[INFO] Log output from vncviewer:"
cat "$LOG_FILE"

EOF

chmod +x lane1-test.sh
./lane1-test.sh
ls
cd tmp
ls
cd ..
ls
cd tmp
ls
nano vncviewer_lane1.log
# Clean everything first
pkill -f "Xvfb :11"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
# Start clean Xvfb
Xvfb :11 -screen 0 480x800x24 &
export DISPLAY=":11"
sleep 2
# Generate xauth
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate :11 . trusted
# Try to run a tiny X11 app (headless-safe)
xclock &
sleep 5
pkill xclock
reboot
sudo reboot
ls
pkill -f "Xvfb :11"
pkill -f "vncviewer .*192.168.4.101"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
./lane1-test.sh
ps aux | grep Xvfb
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd > "/tmp/vncviewer_${IP}.log" 2>&1 &
ls
cd vnc-hls
ls
cd hls
ls
cd ..
ls
cat > new.sh << EOF
[200~#!/bin/bash

set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    echo "[`date`] [INFO] Starting Xvfb on $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date`] [INFO] Xvfb PID: $XVFB_PID"
    sleep 2

    echo "[`date`] [INFO] Generating xauth for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted

    export DISPLAY="$DISPLAY_NUM"

    echo "[`date`] [INFO] Starting vncviewer to connect to $IP"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date`] [INFO] vncviewer PID: $VNC_PID"

    sleep 5

    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date`] [INFO] Starting ffmpeg to capture $DISPLAY_NUM to HLS"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY_NUM"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST"

  } >> "$LOG_FILE" 2>&1 &
done

wait
~
EOF

nano new.sh
systemctl | grep vnc
sudo systemctl stop vnc-to-hls.service
pgrep -af "vncviewer|Xvfb|ffmpeg"
pkill -f "vncviewer"
pkill -f "Xvfb"
pkill -f "ffmpeg"
./new.sh
chmod +x /home/user/vnc-hls/new.sh
chmod +x new.sh
./new.sh
dos2unix /home/user/vnc-hls/new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
ls
mkdir logs
cd vnc-hls
ls
mkdir logs
./new.sh
cd ..
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
for i in "${!IPS[@]}"; do echo "$i - ${IPS[$i]}"; done
cat > test.sh << EOF
#!/bin/bash
set -euo pipefail

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

echo "IPS array: ${IPS[*]}"
echo "DISPLAYS array: ${DISPLAYS[*]}"

for i in "${!IPS[@]}"; do
  echo "Index: $i, IP: ${IPS[$i]}, Display: ${DISPLAYS[$i]}"
done

EOF

./test.sh
chmod -x test.sh
./test.sh
chmod +x test.sh
./test.sh
DISPLAYS=(":11" ":12" ":13" ":14")
echo "${DISPLAYS[@]}"
cat > t2.sh << EOF 
#!/bin/bash
set -euo pipefail

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

echo "IPS array: ${IPS[*]}"
echo "DISPLAYS array: ${DISPLAYS[*]}"

for i in "${!IPS[@]}"; do
  echo "Index: $i, IP: ${IPS[$i]}, Display: ${DISPLAYS[$i]}"
done

EOF

chmod +x t2.sh
./t2/sh
./t2.sh
systemctl | grep vnc
cat > new.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    # Create temporary Xauthority file for this display
    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    # Start Xvfb
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

    sleep 2

    # Generate xauth entry
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

    export DISPLAY="$DISPLAY_NUM"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

    # Start vncviewer in view-only fullscreen mode
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

    sleep 5

    # Prepare ffmpeg streaming
    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

    # Optionally wait here or background all and let systemd manage lifecycle
  } >> "$LOG_FILE" 2>&1 &
done

wait

EOF

chmod +x new.sh
./new.sh
nano new.sh
rm new.sh
ls
cat > new.sh << EOF
mkdir -p "$LOG_DIR"
cat > new.sh << EOF
mkdir -p "$LOG_DIR"
EOF
rm new.sh
cat > new.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    # Create temporary Xauthority file for this display
    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    # Start Xvfb
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

    sleep 2

    # Generate xauth entry
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

    export DISPLAY="$DISPLAY_NUM"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

    # Start vncviewer in view-only fullscreen mode
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

    sleep 5

    # Prepare ffmpeg streaming
    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

    # Optionally wait here or background all and let systemd manage lifecycle
  } >> "$LOG_FILE" 2>&1 &
done

wait

EOF

./new.sh
chmod +x new.sh
./new.sh
nano new.sh
rm new.sh
ls
nano new.sh
ls
cat > ~/new.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

    sleep 2

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

    export DISPLAY="$DISPLAY_NUM"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

    sleep 5

    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info \
      -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY" \
      -vaapi_device "$VAAPI_DEVICE" \
      -vf 'format=nv12,hwupload' \
      -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
      -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list \
      -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
      "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

  } >> "$LOG_FILE" 2>&1 &
done

wait
EOF

ls
nano new.sh
chmod +x new.sh
./new.sh
cat /home/user/vnc-hls/logs/lane4.log
user@vnctranscoder:~$ cat /home/user/vnc-hls/logs/lane4.log
[2025-05-26 18:28:46] [INFO] Starting setup for lane 4 (IP 192.168.4.104, DISPLAY :14)
[2025-05-26 18:28:46] [INFO] Generated XAUTHORITY file at /tmp/.Xauthority.E5sg5j
[2025-05-26 18:28:46] [INFO] Starting Xvfb on display :14
[2025-05-26 18:28:46] [INFO] Xvfb started with PID 1842
The XKEYBOARD keymap compiler (xkbcomp) reports:
> Warning:          Could not resolve keysym XF86CameraAccessEnable
> Warning:          Could not resolve keysym XF86CameraAccessDisable
> Warning:          Could not resolve keysym XF86CameraAccessToggle
> Warning:          Could not resolve keysym XF86NextElement
> Warning:          Could not resolve keysym XF86PreviousElement
> Warning:          Could not resolve keysym XF86AutopilotEngageToggle
> Warning:          Could not resolve keysym XF86MarkWaypoint
> Warning:          Could not resolve keysym XF86Sos
> Warning:          Could not resolve keysym XF86NavChart
> Warning:          Could not resolve keysym XF86FishingChart
> Warning:          Could not resolve keysym XF86SingleRangeRadar
> Warning:          Could not resolve keysym XF86DualRangeRadar
> Warning:          Could not resolve keysym XF86RadarOverlay
> Warning:          Could not resolve keysym XF86TraditionalSonar
> Warning:          Could not resolve keysym XF86ClearvuSonar
> Warning:          Could not resolve keysym XF86SidevuSonar
> Warning:          Could not resolve keysym XF86NavInfo
Errors from xkbcomp are not fatal to the X server
[2025-05-26 18:28:48] [INFO] Generating xauth entry for :14
[2025-05-26 18:28:48] [INFO] xauth entry generated
[2025-05-26 18:28:48] [INFO] DISPLAY set to :14
[2025-05-26 18:28:48] [INFO] Starting vncviewer on 192.168.4.104 (lane 4)
[2025-05-26 18:28:48] [INFO] vncviewer started with PID 1882
The XKEYBOARD keymap compiler (xkbcomp) reports:
> Warning:          Could not resolve keysym XF86CameraAccessEnable
> Warning:          Could not resolve keysym XF86CameraAccessDisable
> Warning:          Could not resolve keysym XF86CameraAccessToggle
> Warning:          Could not resolve keysym XF86NextElement
> Warning:          Could not resolve keysym XF86PreviousElement
> Warning:          Could not resolve keysym XF86AutopilotEngageToggle
> Warning:          Could not resolve keysym XF86MarkWaypoint
> Warning:          Could not resolve keysym XF86Sos
> Warning:          Could not resolve keysym XF86NavChart
> Warning:          Could not resolve keysym XF86FishingChart
> Warning:          Could not resolve keysym XF86SingleRangeRadar
> Warning:          Could not resolve keysym XF86DualRangeRadar
> Warning:          Could not resolve keysym XF86RadarOverlay
> Warning:          Could not resolve keysym XF86TraditionalSonar
> Warning:          Could not resolve keysym XF86ClearvuSonar
> Warning:          Could not resolve keysym XF86SidevuSonar
> Warning:          Could not resolve keysym XF86NavInfo
Errors from xkbcomp are not fatal to the X server
TigerVNC Viewer v1.13.1
Built on: 2024-04-01 08:26
Copyright (C) 1999-2022 TigerVNC Team and many others (see README.rst)
See https://www.tigervnc.org for information on TigerVNC.
Mon May 26 18:28:49 2025
XRequest.131: BadWindow (invalid Window parameter) 0x200005
[2025-05-26 18:28:53] [INFO] Starting ffmpeg capturing :14 and streaming to /home/user/vnc-hls/hls/lane4.m3u8
[2025-05-26 18:28:53] [INFO] ffmpeg started with PID 1918
Input #0, x11grab, from ':14':
[out#0/hls @ 0x5c06ef491900] Codec AVOption sc_threshold (Scene change threshold) has not been used for any stream. The most likely reason is either wrong type (e.g. a video option with no video streams) or that it is a private option of some encoder which was not actually used for any stream.
Stream mapping:
Press [q] to stop, [?] for help
Output #0, hls, to '/home/user/vnc-hls/hls/lane4.m3u8':
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_544.ts' for writing 
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_545.ts' for writing 
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_546.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_547.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_548.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_549.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_550.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_551.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_552.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_553.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_554.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_555.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
frame=  488 fps= 10 q=-0.0 size=N/A time=00:00:48.70 bitrate=N/A speed=   1x    
Mon May 26 18:29:43 2025
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_556.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[200~vncviewer 192.168.4.104:5900
~
vncviewer 192.168.4.104:5900
cat > 4.sh << EOF
#!/bin/bash

# Lane 4 parameters (index 3)
FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IP="192.168.4.104"
DISPLAY_NUM=":14"

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LANE_NUM=4

# Kill related processes by display and IP (adjust grep if needed)
pkill -f "Xvfb $DISPLAY_NUM"
pkill -f "vncviewer.*$IP"
pkill -f "ffmpeg.*$DISPLAY_NUM"

sleep 2

# Start Xvfb
Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
XVFB_PID=$!

sleep 2

# Generate Xauthority
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate "$DISPLAY_NUM" . trusted

export DISPLAY="$DISPLAY_NUM"

# Start vncviewer
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
VNC_PID=$!

sleep 5

# Setup ffmpeg stream paths
HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

# Start ffmpeg
ffmpeg -hide_banner -loglevel info   -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY_NUM"   -vaapi_device "$VAAPI_DEVICE"   -vf 'format=nv12,hwupload'   -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0   -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list   -hls_segment_filename "$HLS_SEGMENT_PATTERN"   "$HLS_PLAYLIST" &
FFMPEG_PID=$!

echo "[INFO] Restarted lane 4: Xvfb PID $XVFB_PID, vncviewer PID $VNC_PID, ffmpeg PID $FFMPEG_PID"

EOF

chmod +x 4.sh
./4.sh
ps
cat > 4n.sh << EOF
#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IP="192.168.4.104"
DISPLAY_NUM=":14"

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LANE_NUM=4

# Kill previous processes by display and IP
pkill -f "Xvfb $DISPLAY_NUM"
pkill -f "vncviewer.*$IP"
pkill -f "ffmpeg.*$DISPLAY_NUM"

sleep 2

# Start Xvfb without quotes on DISPLAY_NUM
Xvfb $DISPLAY_NUM -screen 0 480x800x24 &
XVFB_PID=$!

sleep 2

# Create Xauthority file and export it before running xauth
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate $DISPLAY_NUM . trusted

export DISPLAY=$DISPLAY_NUM

# Start vncviewer
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
VNC_PID=$!

sleep 5

HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

ffmpeg -hide_banner -loglevel info   -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i $DISPLAY_NUM   -vaapi_device $VAAPI_DEVICE   -vf 'format=nv12,hwupload'   -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0   -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list   -hls_segment_filename "$HLS_SEGMENT_PATTERN"   "$HLS_PLAYLIST" &
FFMPEG_PID=$!

echo "[INFO] Restarted lane 4: Xvfb PID $XVFB_PID, vncviewer PID $VNC_PID, ffmpeg PID $FFMPEG_PID"

EOF

chmod +x 4n.sh
./4n.sh
nano 4n.sh
ping 192.168.4.104
./4n.sh
suddo reboot
sudo reboot
cat new.sh
ps
kill 1537
kill 1558
ls
ps
kill 1560
ls
sudo systemctl disable vnc-to-hls.service
sudo systemctl stop vnc-to-hls.sh
sudo reboot
cat > 345.sh < EOF
cat > 345.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5  # seconds base delay, increases linearly per retry

# Function to check if IP is reachable
ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

run_lane() {
  local IP=$1
  local DISPLAY_NUM=$2
  local LANE_NUM=$3
  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  local retry_count=0

  while true; do
    {
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM), attempt $((retry_count + 1))"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Checking network reachability for $IP"
      until ping_check "$IP"; do
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] $IP unreachable, retrying in 5 seconds..."
        sleep 5
      done

      XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
      export XAUTHORITY="$XAUTH_FILE"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
      Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
      XVFB_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

      sleep 2

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
      xauth generate "$DISPLAY_NUM" . trusted
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

      export DISPLAY="$DISPLAY_NUM"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
      vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
      VNC_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

      sleep 5

      HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
      HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
      ffmpeg -hide_banner -loglevel info         -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"         -vaapi_device "$VAAPI_DEVICE"         -vf 'format=nv12,hwupload'         -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0         -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list         -hls_segment_filename "$HLS_SEGMENT_PATTERN"         "$HLS_PLAYLIST"

      # If ffmpeg exits, the script continues here:
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"

      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300  # 5 minutes wait
        retry_count=0
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Restarting retries for lane $LANE_NUM."
      else
        backoff=$((RETRY_DELAY * retry_count))
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Waiting $backoff seconds before next retry on lane $LANE_NUM"
        sleep $backoff
      fi

    } >> "$LOG_FILE" 2>&1
  done
}

# Start all lanes in background
for i in "${!IPS[@]}"; do
  run_lane "${IPS[$i]}" "${DISPLAYS[$i]}" "$((i + 1))" &
done

wait

EOF

chmod +x 345.sh
./345.sh
ls
./345.sh
rm 345.sh
nano 345.sh
rm 345.sh
nano 345.sh
chmod +x 345.sh
./345.sh
p
ps
rn
mv vnc-to-hls.sh vnc-to-hls-old.sh
mv 345.sh vnc-to-hls.sh
git push
ps
sudo reboot
sudo mkdir -p /var/www/html/vnc-status
sudo chown user:www-data /var/www/html/vnc-status
chmod 775 /var/www/html/vnc-status
sed -i '/ffmpeg started with PID/a \ \ \ \ echo "{\"status\":\"ok\",\"ip\":\"$IP\",\"last_updated\":\"$(date \x27+%Y-%m-%d %H:%M:%S\x27)\"}" > "/var/www/html/vnc-status/lane${LANE_NUM}.json"' 345.sh
sed -i '/retry_count=/a \ \ \ \ echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date \x27+%Y-%m-%d %H:%M:%S\x27)\"}" > "/var/www/html/vnc-status/lane${LANE_NUM}.json"' 345.sh
ls
git commit -m "update"
git push
ls
git add .
git commit -m "Update all files with latest monitoring changes"
git push
ls
mkdir status
ls
cd status
ls
cd ..
cd status
pwd
git fetch origin && git reset --hard origin/main
sudo reboot
ls]=
ls
cd status
ls
nano lane1.json
cd ..
ls
where ngninx
whereis nginx
cd etc
cd nginx
nano nginx.config
ls
nano nginx.conf
whereis nginx.conf
nano nginx.conf
cd sites-enabled
ls
grep -r "server {" /etc/nginx/
ls -l /etc/nginx/sites-enabled/
sudo nano /etc/nginx/sites-available/vnc-hls
sudo nginx -t
sudo systemctl reload nginx
git diff
cd ..
cd c..
cd ..
cd home
cd user
ls
git diff
ls
cd status
ls
nano lane4.json
cd ..
ls
mv vnc-to-hls.sh vnc-to-hls.old2
ls
rm Warning:
ls
cd '$OUTPUT_DIR'
ls
cd ..
rm '$OUTPUT_DIR'
rm -r '$OUTPUT_DIR'
rm -r '$LOGFILE'
ls
rm 4.sh
rm4n.sh
rm 4n.sh
rm new.sh
rm t2.sh
rm test.sh
ls
rm lane1-test.sh
ls
cat > vnc-to-hls.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5  # seconds base delay, increases linearly per retry

# Function to check if IP is reachable
ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

run_lane() {
  local IP=$1
  local DISPLAY_NUM=$2
  local LANE_NUM=$3
  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"
  local STATUS_FILE="/home/user/status/lane${LANE_NUM}.json"

  local retry_count=0

  # Initial status write
  echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

  while true; do
    {
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM), attempt $((retry_count + 1))"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Checking network reachability for $IP"
      until ping_check "$IP"; do
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] $IP unreachable, retrying in 5 seconds..."
        sleep 5
      done

      XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
      export XAUTHORITY="$XAUTH_FILE"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
      Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
      XVFB_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

      sleep 2

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
      xauth generate "$DISPLAY_NUM" . trusted
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

      export DISPLAY="$DISPLAY_NUM"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
      vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
      VNC_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

      sleep 5

      HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
      HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
      ffmpeg -hide_banner -loglevel info \
        -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY" \
        -vaapi_device "$VAAPI_DEVICE" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
        -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list \
        -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
        "$HLS_PLAYLIST"

      # ffmpeg exited unexpectedly
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"
      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))
      echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300  # 5 minutes
        retry_count=0
        echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Restarting retries for lane $LANE_NUM."
      else
        backoff=$((RETRY_DELAY * retry_count))
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Waiting $backoff seconds before next retry on lane $LANE_NUM"
        sleep $backoff
      fi
    } >> "$LOG_FILE" 2>&1
  done
}

# Start all lanes in background
for i in "${!IPS[@]}"; do
  run_lane "${IPS[$i]}" "${DISPLAYS[$i]}" "$((i + 1))" &
done

wait
EOF

ls
sudo reboot
ls
./vnc-to-hls.sh
chmod +x vnc-to-hls.sh
./vnc-to-hls.sh
git add .
git commit
git commit -m new
git push
git pull
sudo reboot
./vnc-to-hls.sh
git diff
ls
cd vnc-hls
s
ls
rm hls_display_11
rm -r hls_display_11
rm -r hls_display_12
rm -r hls_display_13
rm -r hls_display_14
rm -r templates
rm -r ngninx_dashboard
rm -r nginx_dashboard
ls
mv index.html index2.html
nano index.html
ls
rm index.html
ls
nano index.html
nano archive.py
chmod +x archive.py
./archive.py
python3 archive.py
mkdir archive
ls
rm archive.py
nano archive.py
chmod +x archive.py
python archive.py
python3 archive.py
ls
cd vnc-hls
ls
mv archive.py ../
ls
cd ..
ls
cd vnc-hls
cd hls
ls
cd ..
ls
rm archive.py
nano archive.py
python3 archive.py
cat > archive.py << 'EOF'
from flask import Flask, send_file, jsonify
import os
from datetime import datetime, timezone
import subprocess
import time

app = Flask(__name__)
ARCHIVE_DIR = "/home/user/vnc-hls/archive"  # clips stored here

# List available clips for a lane, returning timestamps like "20250527-142000"
@app.route('/archive/<lane>/available')
def available_times(lane):
    lane_path = os.path.join(ARCHIVE_DIR, lane)
    if not os.path.isdir(lane_path):
        return jsonify([])

    segments = sorted([
        f.replace('.mp4', '') for f in os.listdir(lane_path)
        if f.endswith('.mp4')
    ])
    return jsonify(segments)

# Serve a clip file by lane and timestamp
@app.route('/archive/<lane>/<timestamp>')
def get_clip(lane, timestamp):
    clip_path = os.path.join(ARCHIVE_DIR, lane, f"{timestamp}.mp4")
    if not os.path.isfile(clip_path):
        return "Not Found", 404
    return send_file(clip_path, as_attachment=True)

def cleanup_old_clips():
    """Delete clips older than 48 hours"""
    cutoff = time.time() - (48 * 3600)
    for lane in os.listdir(ARCHIVE_DIR):
        lane_path = os.path.join(ARCHIVE_DIR, lane)
        if not os.path.isdir(lane_path):
            continue
        for f in os.listdir(lane_path):
            if f.endswith('.mp4'):
                full_path = os.path.join(lane_path, f)
                if os.path.getmtime(full_path) < cutoff:
                    os.remove(full_path)
                    print(f"Deleted old clip: {full_path}")

def create_clip(lane, segment_files):
    """Merge .ts segment files into one mp4 clip with timestamp-based filename"""
    timestamp_str = datetime.utcnow().strftime('%Y%m%d-%H%M%S')
    output_dir = os.path.join(ARCHIVE_DIR, lane)
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{timestamp_str}.mp4")

    if not segment_files:
        print(f"No TS files for {lane}")
        return

    # Build input concat list for ffmpeg
    concat_file_path = os.path.join(output_dir, f"concat_{timestamp_str}.txt")
    with open(concat_file_path, 'w') as f:
        for ts_file in segment_files:
            # full path needed
            full_ts_path = os.path.abspath(ts_file)
            f.write(f"file '{full_ts_path}'\n")

    # Run ffmpeg concat to create mp4
    cmd = [
        "ffmpeg",
        "-f", "concat",
        "-safe", "0",
        "-i", concat_file_path,
        "-c", "copy",
        output_path,
        "-y"
    ]
    print(f"Creating clip: {output_path}")
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.remove(concat_file_path)

def archive_loop():
    """Background loop: every 5 minutes, create clips from TS files, cleanup old clips"""
    lanes = ['lane1', 'lane2', 'lane3', 'lane4']
    base_ts_dir = "/home/user/vnc-hls/hls"

    while True:
        for lane in lanes:
            # Find all .ts files for lane, sorted by filename (assumes TS files are named with increasing number)
            ts_files = sorted(
                [os.path.join(base_ts_dir, f) for f in os.listdir(base_ts_dir)
                 if f.startswith(lane) and f.endswith('.ts')]
            )

            create_clip(lane, ts_files)

        cleanup_old_clips()
        time.sleep(300)  # wait 5 minutes

if __name__ == '__main__':
    import threading
    # Start background archiving thread
    threading.Thread(target=archive_loop, daemon=True).start()

    # Run Flask app
    app.run(host='0.0.0.0', port=5000)
EOF

python3 archive.py
cat > /home/user/archive.py << 'EOF'
import os
import subprocess
import time
from datetime import datetime, timezone
from flask import Flask, send_file, jsonify

app = Flask(__name__)

ARCHIVE_DIR = "/home/user/vnc-hls/archive"
HLS_DIR = "/home/user/vnc-hls/hls"
LANES = ["lane1", "lane2", "lane3", "lane4"]
CLIP_DURATION_SECONDS = 300  # 5 minutes
RETENTION_SECONDS = 48 * 3600  # 48 hours

def create_clip(lane, segment_files):
    timestamp_str = datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')
    output_dir = os.path.join(ARCHIVE_DIR, lane)
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{timestamp_str}.mp4")

    # Create concat file for ffmpeg
    concat_file = f"/tmp/{lane}_concat.txt"
    with open(concat_file, "w") as f:
        for segment in segment_files:
            f.write(f"file '{os.path.join(HLS_DIR, segment)}'\n")

    # ffmpeg command to concatenate and convert .ts files into one mp4 clip
    cmd = [
        "ffmpeg",
        "-y",
        "-f", "concat",
        "-safe", "0",
        "-i", concat_file,
        "-c", "copy",
        output_path
    ]

    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.remove(concat_file)
    print(f"Creating clip: {output_path}")

def cleanup_old_clips():
    cutoff = time.time() - RETENTION_SECONDS
    for lane in LANES:
        lane_path = os.path.join(ARCHIVE_DIR, lane)
        if not os.path.isdir(lane_path):
            continue
        for filename in os.listdir(lane_path):
            if filename.endswith(".mp4"):
                filepath = os.path.join(lane_path, filename)
                if os.path.getmtime(filepath) < cutoff:
                    os.remove(filepath)
                    print(f"Deleted old clip: {filepath}")

def archive_loop():
    while True:
        for lane in LANES:
            ts_files = sorted([f for f in os.listdir(HLS_DIR) if f.startswith(lane) and f.endswith(".ts")])
            if not ts_files:
                print(f"No TS files for {lane}")
                continue

            # Select last N segments to cover ~5 minutes (assuming ~10s per segment)
            segment_count = CLIP_DURATION_SECONDS // 10
            segments_to_use = ts_files[-segment_count:]

            create_clip(lane, segments_to_use)
        cleanup_old_clips()
        time.sleep(CLIP_DURATION_SECONDS)

@app.route('/archive/<lane>/available')
def available_times(lane):
    lane_path = os.path.join(ARCHIVE_DIR, lane)
    if not os.path.isdir(lane_path):
        return jsonify([])

    clips = sorted([
        f.replace('.mp4', '') for f in os.listdir(lane_path)
        if f.endswith('.mp4')
    ])
    return jsonify(clips)

@app.route('/archive/<lane>/<timestamp>')
def get_clip(lane, timestamp):
    clip_path = os.path.join(ARCHIVE_DIR, lane, f"{timestamp}.mp4")
    if not os.path.isfile(clip_path):
        return "Not Found", 404
    return send_file(clip_path, as_attachment=True)

if __name__ == '__main__':
    import threading
    threading.Thread(target=archive_loop, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
EOF

python3 archive.py
cat > ~/vnc-hls/dev-scripts/archive_30min_blocks.py << 'EOF'
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
EOF

chmod +x ~/vnc-hls/dev-scripts/archive_30min_blocks.py
python3 archive_30min_blocks.py
python3 /dev-scripts/archive_30min_blocks.py
cd dev-scripts
cat > ~/vnc-hls/archive_30min_blocks.py << 'EOF'
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
EOF

chmod +x ~/vnc-hls/dev-scripts/archive_30min_blocks.py
python3 /dev-scripts/archive_30min_blocks.py
ls
cat > ~/vnc-hls/archive_30min_blocks.py << 'EOF'
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
EOF

chmod +x ~/vnc-hls/dev-scripts/archive_30min_blocks.py
cat > ~/vnc-hls/archive_30min_blocks.py << 'EOF'
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
EOF

chmod +x ~/vnc-hls/archive_30min_blocks.py
chmod +x ~/vnc-hls/dev-scripts/archive_30min_blocks.py
python3 archive_30min_blocks.py
ls
cat > archive_30min_blocks.py << 'EOF'
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
EOF

chmod +x ~/vnc-hls/archive_30min_blocks.py
ls
chmod +x ~/vnc-hls/archive_30min_blocks.py
chmod +x archive_30min_blocks.py
./archive_30min_blocks.py
python3 archive_30min_blocks.py
ls
cd hls
cd vnc-hls
cd hls
ls
cd ..
ls
mv vnc-to-hls.sh vnc-to-hls.old3
nano vnc-to-hls.sh
chmod +x vnc-to-hls.sh
./vnc-to-hls.sh
sudo reboot
ls
cd status
ls
cd ..
ls
cd vnc-hls
ls
nano index3.html
ls
cd hls
ls
cd ..
ls
cat vnc-to-hls.sh
cd ..
cat vnc-to-hls.sh
rm vnc-to-hls.sh
nano vnc-to-hls.sh
chmod +x vnc-to-hls.sh
./ vnc-to-hls.sh
./vnc-to-hls.sh
sudo reboot
ls
cd vnc-hls
ls
mv index.html index5.html
mv index3.html index.html
cd ..
ls
mv vnc-to-hls.sh vnc-to-hls.old4
ls
nano vnc-to-hls.sh
sudo reboot
