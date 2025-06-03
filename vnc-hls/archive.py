#!/usr/bin/env python3

import os
import time
import subprocess
import re
from datetime import datetime, timedelta

HLS_DIR = "/home/user/vnc-hls/hls"
ARCHIVE_DIR = "/home/user/vnc-hls/archive"
LANES = ["lane1", "lane2", "lane3", "lane4"]

def extract_timestamp(segment_name):
    # Extract timestamp from filenames like segment_YYYYMMDD-HHMMSS.ts
    match = re.search(r'segment_(\d{8}-\d{6})\.ts$', segment_name)
    if match:
        return datetime.strptime(match.group(1), '%Y%m%d-%H%M%S')
    else:
        return None

def create_clip(lane, segment_files):
    first_ts = extract_timestamp(segment_files[0])
    if first_ts is None:
        first_ts = datetime.now()
    timestamp_str = first_ts.strftime('%Y%m%d-%H%M%S')

    output_dir = os.path.join(ARCHIVE_DIR, lane)
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{lane}_{timestamp_str}.mp4")

    concat_file = f"/tmp/{lane}_concat.txt"
    with open(concat_file, "w") as f:
        for segment in segment_files:
            segment_path = os.path.join(HLS_DIR, lane, segment)
            f.write(f"file '{segment_path}'\n")

    subprocess.run(
        [
            "ffmpeg",
            "-y",
            "-f", "concat",
            "-safe", "0",
            "-i", concat_file,
            "-c", "copy",
            output_path,
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    os.remove(concat_file)
    print(f"Created clip: {output_path}")

def cleanup_old_clips(max_age_days=7):
    cutoff = datetime.now() - timedelta(days=max_age_days)
    for lane in LANES:
        lane_dir = os.path.join(ARCHIVE_DIR, lane)
        if not os.path.isdir(lane_dir):
            continue
        for filename in os.listdir(lane_dir):
            if filename.endswith(".mp4"):
                filepath = os.path.join(lane_dir, filename)
                file_mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
                if file_mtime < cutoff:
                    os.remove(filepath)
                    print(f"Deleted old clip: {filepath}")

def archive_loop():
    SEGMENT_DURATION = 4  # seconds per .ts segment from your ffmpeg command
    CLIP_DURATION_SECONDS = 300  # 5 minutes total clip length
    segment_count = CLIP_DURATION_SECONDS // SEGMENT_DURATION  # 75 segments

    while True:
        for lane in LANES:
            lane_dir = os.path.join(HLS_DIR, lane)
            if not os.path.isdir(lane_dir):
                print(f"Lane directory missing: {lane_dir}")
                continue

            ts_files = [f for f in os.listdir(lane_dir) if f.endswith(".ts")]
            ts_files = sorted(ts_files, key=extract_timestamp)

            if len(ts_files) < segment_count:
                print(f"Not enough segments for {lane} yet ({len(ts_files)} < {segment_count})")
                continue

            segments_to_use = ts_files[-segment_count:]
            create_clip(lane, segments_to_use)

        cleanup_old_clips()

        # Sleep half the clip duration so clips overlap and no gaps appear
        time.sleep(CLIP_DURATION_SECONDS // 2)

if __name__ == "__main__":
    archive_loop()

