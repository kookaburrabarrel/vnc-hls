#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IP="192.168.4.104"
DISPLAY_NUM=":14"

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LANE_NUM=4

# Kill previous processes by display and IP
pkill -f "Xvfb "
pkill -f "vncviewer.*"
pkill -f "ffmpeg.*"

sleep 2

# Start Xvfb without quotes on DISPLAY_NUM
Xvfb  -screen 0 480x800x24 &
XVFB_PID=1576

sleep 2

# Create Xauthority file and export it before running xauth
XAUTH_FILE=/tmp/.Xauthority.D1dy9f
export XAUTHORITY=""
xauth generate  . trusted

export DISPLAY=

# Start vncviewer
vncviewer -ViewOnly=1 -Fullscreen=1 ":5900" -passwd /home/user/.vnc/passwd &
VNC_PID=1576

sleep 5

HLS_PLAYLIST="/.m3u8"
HLS_SEGMENT_PATTERN="/_%03d.ts"

ffmpeg -hide_banner -loglevel info   -f x11grab -r  -s  -i    -vaapi_device    -vf 'format=nv12,hwupload'   -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0   -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list   -hls_segment_filename ""   "" &
FFMPEG_PID=1576

echo "[INFO] Restarted lane 4: Xvfb PID , vncviewer PID , ffmpeg PID "

