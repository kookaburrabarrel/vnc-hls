
#!/bin/bash

set -euo pipefail

XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY=$XAUTH_FILE

# Start virtual display if needed, uncomment if headless
# Xvfb :99 -screen 0 480x800x24 &
# XVFB_PID=$!
# export DISPLAY=:99

# Launch TigerVNC viewer in background
vncviewer -ViewOnly=1 -Fullscreen=1 192.168.4.101:5900 -passwd ~/.vnc/passwd &
VNC_PID=$!

# Wait for VNC viewer window to open and settle
sleep 5

# Run ffmpeg to capture the X11 display and encode to HLS
ffmpeg -f x11grab -r 10 -s 480x800 -i $DISPLAY \
  -c:v h264_vaapi -vf 'format=nv12,hwupload' \
  -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
  -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
  -hls_segment_filename ~/vnc-hls/hls/lane1_%03d.ts \
  ~/vnc-hls/hls/lane1.m3u8

# Cleanup
kill $VNC_PID 2>/dev/null || true
[ -n "${XVFB_PID:-}" ] && kill $XVFB_PID 2>/dev/null || true
rm -f "$XAUTH_FILE"

