#!/bin/bash
set -e

# Config - fix these variables properly
VNC_HOST="192.168.4.101"
VNC_PORT=5900
VNC_PASS="wuotu1Iocheegi6u"

OUTPUT_DIR="./hls_output"
XVFB_DISPLAY=":99"
WIDTH=480
HEIGHT=800

# Cleanup any existing Xvfb on :99
pkill Xvfb || true
rm -f /tmp/.X99-lock

mkdir -p "$OUTPUT_DIR"

echo "Starting Xvfb on display $XVFB_DISPLAY with resolution ${WIDTH}x${HEIGHT}x24"
Xvfb $XVFB_DISPLAY -screen 0 ${WIDTH}x${HEIGHT}x24 &
XVFB_PID=$!

sleep 2  # wait for Xvfb

echo "Creating VNC password file"
echo "$VNC_PASS" > /tmp/vnc_passwd
chmod 600 /tmp/vnc_passwd

echo "Starting xtightvncviewer connecting to $VNC_HOST:$((VNC_PORT - 5900))"
DISPLAY=$XVFB_DISPLAY xtightvncviewer -passwd /tmp/vnc_passwd $VNC_HOST:$((VNC_PORT - 5900)) &
VNC_PID=$!

sleep 5  # wait for VNC viewer to connect

echo "Starting ffmpeg to capture Xvfb display and generate HLS stream in $OUTPUT_DIR"
ffmpeg -y -video_size ${WIDTH}x${HEIGHT} -framerate 30 -f x11grab -i $XVFB_DISPLAY.0 \
  -c:v libx264 -profile:v high444 -preset veryfast -b:v 2000k -pix_fmt yuv444p \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+append_list \
  "$OUTPUT_DIR/playlist.m3u8"

echo "Cleaning up"
kill $XVFB_PID
kill $VNC_PID
rm -f /tmp/vnc_passwd
