from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

HLS_FOLDER = os.path.expanduser('~/vnc-hls/hls')

@app.route('/')
def index():
    # List of lanes with URLs relative to Flask static serving
    lanes = [
        'lane1.m3u8',
        'lane2.m3u8',
        'lane3.m3u8',
        'lane4.m3u8'
    ]
    return render_template('index.html', lanes=lanes)

@app.route('/hls/<path:filename>')
def hls_files(filename):
    return send_from_directory(HLS_FOLDER, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=49494, debug=True)
