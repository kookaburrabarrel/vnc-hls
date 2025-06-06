#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

CONFIG_FILE="$(dirname "$0")/config.json"

# Read lanes IPs and ports from config.json
mapfile -t IPS < <(jq -r '.gates | to_entries[] | .value | to_entries[] | .value.ip' "$CONFIG_FILE")
mapfile -t PORTS < <(jq -r '.gates | to_entries[] | .value | to_entries[] | .value.port' "$CONFIG_FILE")

# Displays must match the number of lanes
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5

ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

timestamp() {
  date +%s
}

run_lane() {
  local IP=$1
  local PORT=$2
  local DISPLAY_NUM=$3
  local LANE_NUM=$4

  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"
  local STATUS_FILE="/home/user/vnc-hls/status/lane${LANE_NUM}.json"
  local retry_count=0

  local LANE_HLS_DIR="$HLS_BASE/lane${LANE_NUM}"
  mkdir -p "$LANE_HLS_DIR"

  local HLS_PLAYLIST="$LANE_HLS_DIR/stream.m3u8"
  local HLS_SEGMENT_PATTERN="$LANE_HLS_DIR/segment_%Y%m%d-%H%M%S.ts"

  update_status() {
    local status=$1
    local message=""
    if (( retry_count == 0 )) && [[ "$status" == "error" ]]; then
      message="Retrying..."
    else
      if [[ "$status" == "error" ]]; then
        message="retry $retry_count"
      else
        message="$2"
      fi
    fi
    echo "{\"status\":\"$status\",\"ip\":\"$IP\",\"message\":\"$message\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"
  }

  update_status error

  while true; do
    {
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, PORT $PORT, DISPLAY $DISPLAY_NUM), attempt $((retry_count + 1))"

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

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP:$PORT (lane $LANE_NUM)"
      vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:$PORT" -passwd /home/user/.vnc/passwd &
      VNC_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

      sleep 5

      retry_count=0
      update_status ok "streaming"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
      ffmpeg -hide_banner -loglevel info \
        -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY" \
        -vaapi_device "$VAAPI_DEVICE" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
        -hls_time 4 \
        -hls_list_size 43200 \
        -hls_flags append_list \
        -strftime 1 \
        -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
        "$HLS_PLAYLIST"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"
      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))
      update_status error

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300
        retry_count=0
        update_status error
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Restarting retries for lane $LANE_NUM."
      else
        backoff=$((RETRY_DELAY * retry_count))
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Waiting $backoff seconds before next retry on lane $LANE_NUM"
        sleep $backoff
      fi
    } >> "$LOG_FILE" 2>&1
  done
}

for i in "${!IPS[@]}"; do
  run_lane "${IPS[$i]}" "${PORTS[$i]}" "${DISPLAYS[$i]}" "$((i + 1))" &
done

wait
