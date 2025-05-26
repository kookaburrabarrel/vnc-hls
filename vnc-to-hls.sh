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
    echo "{"status":"error","ip":"$IP","message":"retry $retry_count","last_updated":"$(date '+%Y-%m-%d %H:%M:%S')"}" > "/var/www/html/vnc-status/lane${LANE_NUM}.json"

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

      # If ffmpeg exits, the script continues here:
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"

      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))
    echo "{"status":"error","ip":"$IP","message":"retry $retry_count","last_updated":"$(date '+%Y-%m-%d %H:%M:%S')"}" > "/home/user/status/lane${LANE_NUM}.json"

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300  # 5 minutes wait
        retry_count=0
    echo "{"status":"error","ip":"$IP","message":"retry $retry_count","last_updated":"$(date '+%Y-%m-%d %H:%M:%S')"}" > "/home/user/status/lane${LANE_NUM}.json"
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
