#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=/tmp/.Xauthority.3eecN5
export XAUTHORITY="/tmp/.Xauthority.mVdYO5"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=1617
sleep 2

xauth generate :11 . trusted

# Log output path
LOG_FILE="/tmp/vncviewer_lane1.log"

# Start vncviewer with logging
vncviewer -ViewOnly=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > "" 2>&1 &
VNC_PID=1617

echo "[INFO] Xvfb PID: 1614"
echo "[INFO] vncviewer PID: 1617"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

# Cleanup
kill 1617
kill 1614
rm -f "/tmp/.Xauthority.mVdYO5"

echo "[INFO] Log output from vncviewer:"
cat ""

