#!/bin/bash
VNC_URL=$1
LANE=$2

ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 \
       -f vnc -i $VNC_URL \
       -vf 'format=nv12,hwupload=extra_hw_frames=64' \
       -c:v h264_vaapi -preset fast -b:v 1M \
       -f hls -hls_time 2 -hls_list_size 4 -hls_flags delete_segments \
       ./hls/${LANE}_index.m3u8
