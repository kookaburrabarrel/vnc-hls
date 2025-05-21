#!/bin/bash
DISPLAY_ID=":101"
xvfb-run -n 101 -s "-screen 0 480x800x24" x11vnc \
  -display "$DISPLAY_ID" \
  -passwd wuotu1Iocheegi6u \
  -noxdamage -forever &
X11VNC_PID=$!
ffmpeg -hide_banner -loglevel info -vaapi_device /dev/dri/renderD128 \
  -f x11grab -r 10 -s 480x800 -i "$DISPLAY_ID" \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi -b:v 1500k -g 30 -keyint_min 30 \
  -f hls \
  -hls_time 2 -hls_list_size 5 \
  -hls_flags delete_segments+append_list \
  ~/vnc-hls/hls/lane3.m3u8 &
FFMPEG_PID=$!
wait $X11VNC_PID $FFMPEG_PID
