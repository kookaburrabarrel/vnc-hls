#!/bin/bash

DEV="/dev/dri/renderD128"
RES="480x800"
FPS=10
BITRATE="1M"
HLS_TIME=2
HLS_LIST_SIZE=3

for DISP in 11 12 13 14; do
  DISPLAY=":$DISP"
  OUTPUT_DIR="hls_display_${DISP}"
  mkdir -p $OUTPUT_DIR

  echo "Starting capture on DISPLAY=$DISPLAY -> $OUTPUT_DIR/stream.m3u8"

  DISPLAY=$DISPLAY ffmpeg -vaapi_device $DEV -f x11grab -r $FPS -s $RES -i $DISPLAY \
    -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v $BITRATE \
    -f hls -hls_time $HLS_TIME -hls_list_size $HLS_LIST_SIZE -hls_flags delete_segments \
    $OUTPUT_DIR/stream.m3u8 &
done

wait
