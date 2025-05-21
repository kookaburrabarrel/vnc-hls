#!/bin/bash
set -euo pipefail

# Target resolution and frame rate
RESOLUTION="480x800"
FRAMERATE=10
DISPLAY_ID=":99.0"
OUTPUT_DIR="/var/www/html/vnc1"
OUTPUT_FILE="stream.m3u8"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Check for VAAPI device
if [ -e /dev/dri/renderD128 ]; then
    echo "[INFO] VAAPI device found. Using hardware acceleration."

    ffmpeg -vaapi_device /dev/dri/renderD128 \
        -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE"

else
    echo "[WARN] VAAPI device not found. Falling back to CPU encoding."

    ffmpeg -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE"
fi
