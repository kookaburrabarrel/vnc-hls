#!/bin/bash

# Directories to clean
DIRS=(
  "/home/user/vnc-hls/hls/lane1"
  "/home/user/vnc-hls/hls/lane2"
  "/home/user/vnc-hls/hls/lane3"
  "/home/user/vnc-hls/hls/lane4"
  "/home/user/vnc-hls/archive/lane1"
  "/home/user/vnc-hls/archive/lane2"
  "/home/user/vnc-hls/archive/lane3"
  "/home/user/vnc-hls/archive/lane4"
)

# Log directory
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/cleanup.log"

# Timestamp
NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$NOW] Cleanup started" >> "$LOG_FILE"

# Delete files older than 24 hours
for DIR in "${DIRS[@]}"; do
  if [ -d "$DIR" ]; then
    find "$DIR" -type f \( -name "*.ts" -o -name "*.mp4" \) -mmin +1440 -print -delete >> "$LOG_FILE"
  else
    echo "[$NOW] Directory not found: $DIR" >> "$LOG_FILE"
  fi
done

echo "[$NOW] Cleanup completed" >> "$LOG_FILE"
