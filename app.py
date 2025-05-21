from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

BASE_OUTPUT = '/home/user/hls'  # match your vnctranscode.sh path

@app.route('/hls/<lane>/<path:filename>')
def hls_files(lane, filename):
    lane_dir = os.path.join(BASE_OUTPUT, lane)
    return send_from_directory(lane_dir, filename)

@app.route('/')
def index():
    streams = {
        'Lane 1': '/hls/lane1/stream.m3u8',
        'Lane 2': '/hls/lane2/stream.m3u8',
        'Lane 3': '/hls/lane3/stream.m3u8',
    }
    return render_template('index.html', streams=streams)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=49494)
