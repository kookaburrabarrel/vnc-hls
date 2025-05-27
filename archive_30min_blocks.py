#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import subprocess
from pathlib import Path

HLS_DIR = '/home/user/vnc-hls/hls'
ARCHIVE_DIR = '/home/user/vnc-hls/archive'
LANES = ['lane1', 'lane2', 'lane3', 'lane4']

def aligned_wait():
    now = datetime.now()
    minute = now.minute
    if minute < 30:
        next_run = now.replace(minute=30, second=0, microsecond=0)
    else:
        next_run = (now + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
    wait_time = (next_run - now).total_seconds()
    print(f"[{now}] Sleeping for {wait_time:.1f} seconds until {next_run}")
    time.sleep(wait_time)

def find_ts_files(lane, start_ts, end_ts):
    ts_files = []
    for fname in sorted(os.listdir(HLS_DIR)):
        if fname.startswith(lane + '_') and fname.endswith('.ts'):
            full_path = os.path.join(HLS_DIR, fname)
            ctime = os.path.getctime(full_path)
            if start_ts <= ctime < end_ts:
                ts_files.append(full_path)
    return ts_files

def archive_lane(lane, start_time):
    end_time = start_time + timedelta(minutes=30)
    start_ts = start_time.timestamp()
    end_ts = end_time.timestamp()

    ts_files = find_ts_files(lane, start_ts, end_ts)
    if not ts_files:
        print(f"[{datetime.now()}] No TS files found for {lane} between {start_time} and {end_time}")
        return

    list_path = f'/tmp/{lane}_inputs.txt'
    with open(list_path, 'w') as f:
        for ts in ts_files:
            f.write(f"file '{ts}'\n")

    timestamp_label = start_time.strftime('%Y-%m-%d_%H-%M')
    output_path = os.path.join(ARCHIVE_DIR, f'{lane}_{timestamp_label}.mp4')

    print(f"[{datetime.now()}] Archiving {lane} to {output_path} with {len(ts_files)} segments...")
    cmd = [
        'ffmpeg',
        '-y',
        '-f', 'concat',
        '-safe', '0',
        '-i', list_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main_loop():
    while True:
        now = datetime.now()
        # Align to last :00 or :30
        minute = 0 if now.minute < 30 else 30
        aligned_start = now.replace(minute=minute, second=0, microsecond=0) - timedelta(minutes=30)

        for lane in LANES:
            archive_lane(lane, aligned_start)

        aligned_wait()

if __name__ == '__main__':
    main_loop()
