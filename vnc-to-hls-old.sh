#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  
  XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
  export XAUTHORITY="$XAUTH_FILE"

  echo "[INFO] Starting Xvfb on display $DISPLAY_NUM for IP $IP"
  Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
  XVFB_PID=$!

  sleep 2

  xauth generate "$DISPLAY_NUM" . trusted

  export DISPLAY="$DISPLAY_NUM"

  echo "[INFO] Starting vncviewer on $IP with display $DISPLAY_NUM"
  vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
  VNC_PID=$!

  sleep 5

  HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1)).m3u8"
  HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1))_%03d.ts"

  echo "[INFO] Starting ffmpeg capturing $DISPLAY_NUM and streaming to $HLS_PLAYLIST"
  ffmpeg -hide_banner -loglevel info \
    -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY_NUM" \
    -vaapi_device "$VAAPI_DEVICE" \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list \
    -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
    "$HLS_PLAYLIST" &
done

wait
