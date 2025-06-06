from flask import Flask, send_from_directory, jsonify, abort
from flask_cors import CORS
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

ARCHIVE_ROOT = '/home/user/vnc-hls/archive'

@app.route('/archive/<lane>/available')
def available_clips(lane):
    lane_dir = os.path.join(ARCHIVE_ROOT, lane)
    if not os.path.isdir(lane_dir):
        abort(404, description='Lane not found')

    clips = []
    for f in os.listdir(lane_dir):
        if f.endswith('.mp4') and f.startswith(f"{lane}_"):
            clips.append(f[:-4])  # Strip '.mp4'
    clips.sort()

    date_range = None
    if clips:
        try:
            timestamps = [clip[len(lane)+1:] for clip in clips]
            start_dt = datetime.strptime(timestamps[0], "%Y%m%d-%H%M%S")
            end_dt = datetime.strptime(timestamps[-1], "%Y%m%d-%H%M%S")
            date_range = f"{start_dt.strftime('%B %-d, %-I:%M %p')} to {end_dt.strftime('%B %-d, %-I:%M %p')}"
        except Exception:
            date_range = None

    return jsonify({
        "clips": clips,
        "date_range": date_range
    })

@app.route('/archive/<lane>/<clip>')
def serve_clip(lane, clip):
    lane_dir = os.path.join(ARCHIVE_ROOT, lane)
    filename = f"{clip}.mp4"
    if not os.path.isfile(os.path.join(lane_dir, filename)):
        abort(404, description='Clip not found')
    return send_from_directory(lane_dir, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

