#!/bin/bash

# Configuration
DISPLAY_ID="$1"         # Example: :1.0
OUTPUT_DIR="/var/www/html/hls_display_$2"
OUTPUT_FILE="stream.m3u8"
RESOLUTION="480x800"
FRAMERATE="10"
LOGFILE="/var/log/vnc_to_hls_$2.log"

mkdir -p "$OUTPUT_DIR"

echo "[INFO] Starting X11 HLS stream for display $DISPLAY_ID" | tee -a "$LOGFILE"

# Check for VAAPI support
if ls /dev/dri/renderD* &>/dev/null; then
    echo "[INFO] VAAPI device found. Using hardware acceleration." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
else
    echo "[WARN] VAAPI device not found. Falling back to CPU encoding." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
fi
