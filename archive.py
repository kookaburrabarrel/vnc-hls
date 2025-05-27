import os
import subprocess
import time
from datetime import datetime, timezone
from flask import Flask, send_file, jsonify

app = Flask(__name__)

ARCHIVE_DIR = "/home/user/vnc-hls/archive"
HLS_DIR = "/home/user/vnc-hls/hls"
LANES = ["lane1", "lane2", "lane3", "lane4"]
CLIP_DURATION_SECONDS = 300  # 5 minutes
RETENTION_SECONDS = 48 * 3600  # 48 hours

def create_clip(lane, segment_files):
    timestamp_str = datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')
    output_dir = os.path.join(ARCHIVE_DIR, lane)
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{timestamp_str}.mp4")

    # Create concat file for ffmpeg
    concat_file = f"/tmp/{lane}_concat.txt"
    with open(concat_file, "w") as f:
        for segment in segment_files:
            f.write(f"file '{os.path.join(HLS_DIR, segment)}'\n")

    # ffmpeg command to concatenate and convert .ts files into one mp4 clip
    cmd = [
        "ffmpeg",
        "-y",
        "-f", "concat",
        "-safe", "0",
        "-i", concat_file,
        "-c", "copy",
        output_path
    ]

    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.remove(concat_file)
    print(f"Creating clip: {output_path}")

def cleanup_old_clips():
    cutoff = time.time() - RETENTION_SECONDS
    for lane in LANES:
        lane_path = os.path.join(ARCHIVE_DIR, lane)
        if not os.path.isdir(lane_path):
            continue
        for filename in os.listdir(lane_path):
            if filename.endswith(".mp4"):
                filepath = os.path.join(lane_path, filename)
                if os.path.getmtime(filepath) < cutoff:
                    os.remove(filepath)
                    print(f"Deleted old clip: {filepath}")

def archive_loop():
    while True:
        for lane in LANES:
            ts_files = sorted([f for f in os.listdir(HLS_DIR) if f.startswith(lane) and f.endswith(".ts")])
            if not ts_files:
                print(f"No TS files for {lane}")
                continue

            # Select last N segments to cover ~5 minutes (assuming ~10s per segment)
            segment_count = CLIP_DURATION_SECONDS // 10
            segments_to_use = ts_files[-segment_count:]

            create_clip(lane, segments_to_use)
        cleanup_old_clips()
        time.sleep(CLIP_DURATION_SECONDS)

@app.route('/archive/<lane>/available')
def available_times(lane):
    lane_path = os.path.join(ARCHIVE_DIR, lane)
    if not os.path.isdir(lane_path):
        return jsonify([])

    clips = sorted([
        f.replace('.mp4', '') for f in os.listdir(lane_path)
        if f.endswith('.mp4')
    ])
    return jsonify(clips)

@app.route('/archive/<lane>/<timestamp>')
def get_clip(lane, timestamp):
    clip_path = os.path.join(ARCHIVE_DIR, lane, f"{timestamp}.mp4")
    if not os.path.isfile(clip_path):
        return "Not Found", 404
    return send_file(clip_path, as_attachment=True)

if __name__ == '__main__':
    import threading
    threading.Thread(target=archive_loop, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
