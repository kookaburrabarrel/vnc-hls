#!/bin/bash
nohup ~/vnc-hls/bin/lane1.sh > ~/vnc-hls/lane1.log 2>&1 &
nohup ~/vnc-hls/bin/lane2.sh > ~/vnc-hls/lane2.log 2>&1 &
nohup ~/vnc-hls/bin/lane3.sh > ~/vnc-hls/lane3.log 2>&1 &
# Launch Flask on port 57433
nohup python3 ~/vnc-hls/app.py --port 57433 > ~/vnc-hls/flask.log 2>&1 &
