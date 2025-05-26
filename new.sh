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
