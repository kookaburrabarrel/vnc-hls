#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"

for i in ${!IPS[@]}; do
  IP=${IPS[$i]}
  DISPLAY=${DISPLAYS[$i]}
  
  HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1)).m3u8"
  HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1))_%d.ts"

  echo "[INFO] Starting stream from $IP on display $DISPLAY"

  ffmpeg -hide_banner -loglevel info \
    -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i $DISPLAY \
    -vaapi_device "$VAAPI_DEVICE" \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
    "$HLS_PLAYLIST" &
done

wait
