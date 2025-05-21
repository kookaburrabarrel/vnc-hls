#!/bin/bash
set -e

HLS_DIR="/home/user/vnc-hls/hls"
mkdir -p "$HLS_DIR"

echo "Killing old ffmpeg, vncviewer and Xvfb processes..."
pkill -f "ffmpeg.*lane" || true
pkill -f "vncviewer.*lane" || true
pkill -f "Xvfb :10" || true
pkill -f "Xvfb :11" || true
pkill -f "Xvfb :12" || true
pkill -f "Xvfb :13" || true
sleep 2

for i in 1 2 3 4; do
  DISPLAY_NUM=$((10 + i))  # use :11, :12, :13, :14 (lower numbers)
  export DISPLAY=:$DISPLAY_NUM
  XAUTH_FILE="/tmp/.Xauthority_lane${i}"
  export XAUTHORITY=$XAUTH_FILE

  # Start Xvfb virtual display
  Xvfb $DISPLAY -screen 0 480x800x24 &

  XVFB_PID=$!
  echo "Started Xvfb for lane${i} on DISPLAY $DISPLAY (PID $XVFB_PID)"

  sleep 3  # give Xvfb time to start

  # Generate a new xauth cookie for this display
  xauth -f "$XAUTH_FILE" generate $DISPLAY . trusted

  # Start TigerVNC viewer inside the Xvfb display in view-only mode
  DISPLAY=$DISPLAY vncviewer -ViewOnly=1 192.168.4.10${i}:5900 -passwd ~/.vnc/passwd &

  VNC_PID=$!
  echo "Started vncviewer lane${i} on DISPLAY $DISPLAY (PID $VNC_PID)"

  sleep 5  # wait for VNC viewer to fully load

  # Run FFmpeg capturing the X11 virtual display for lane i
  ffmpeg -loglevel info -y \
    -f x11grab -r 10 -s 480x800 -i $DISPLAY \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi \
    -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "${HLS_DIR}/lane${i}_%03d.ts" \
    "${HLS_DIR}/lane${i}.m3u8" &

  echo "Started ffmpeg lane${i}"
done

echo "All 4 streams started."
