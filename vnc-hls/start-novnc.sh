#!/bin/bash

export DISPLAY=:1

# Start virtual framebuffer with 480x800 resolution
Xvfb :1 -screen 0 480x800x24 &

# Give Xvfb a second to initialize
sleep 1

# Start VNC server
x11vnc -display :1 -forever -nopw -shared -noxdamage &

# Start noVNC (serves from the ~/noVNC folder)
websockify --web ~/noVNC 6080 localhost:5900 &
