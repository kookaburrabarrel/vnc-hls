</body>
</html>
EOF

sudo reboot
cd vnc-hls
cd hls
ls
cd lane1
ls
cd ..
cat vnc-to-hls.sh
cat > ~/vnc-to-hls.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5  # seconds base delay, increases linearly per retry

ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

sanitize_ip() {
  echo "$1" | tr '.' '_'
}

timestamp() {
  date +%s
}

run_lane() {
  local IP=$1
  local DISPLAY_NUM=$2
  local LANE_NUM=$3

  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"
  local STATUS_FILE="/home/user/status/lane${LANE_NUM}.json"
  local retry_count=0

  local LANE_HLS_DIR="$HLS_BASE/lane${LANE_NUM}"
  mkdir -p "$LANE_HLS_DIR"

  local HLS_PLAYLIST="$LANE_HLS_DIR/stream.m3u8"
  local HLS_SEGMENT_PATTERN="$LANE_HLS_DIR/segment_%Y%m%d-%H%M%S.ts"

  echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

  while true; do
    {
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM), attempt $((retry_count + 1))"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Checking network reachability for $IP"
      until ping_check "$IP"; do
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] $IP unreachable, retrying in 5 seconds..."
        sleep 5
      done

      XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
      export XAUTHORITY="$XAUTH_FILE"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
      Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
      XVFB_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

      sleep 2

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
      xauth generate "$DISPLAY_NUM" . trusted
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

      export DISPLAY="$DISPLAY_NUM"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
      vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
      VNC_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

      sleep 5

      retry_count=0
      echo "{\"status\":\"ok\",\"ip\":\"$IP\",\"message\":\"streaming\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$_


cat > ~/vnc-to-hls.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5  # seconds base delay, increases linearly per retry

ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

sanitize_ip() {
  echo "$1" | tr '.' '_'
}

timestamp() {
  date +%s
}

run_lane() {
  local IP=$1
  local DISPLAY_NUM=$2
  local LANE_NUM=$3

  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"
  local STATUS_FILE="/home/user/status/lane${LANE_NUM}.json"
  local retry_count=0

  local LANE_HLS_DIR="$HLS_BASE/lane${LANE_NUM}"
  mkdir -p "$LANE_HLS_DIR"

  local HLS_PLAYLIST="$LANE_HLS_DIR/stream.m3u8"
  local HLS_SEGMENT_PATTERN="$LANE_HLS_DIR/segment_%Y%m%d-%H%M%S.ts"

  echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

  while true; do
    {
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM), attempt $((retry_count + 1))"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Checking network reachability for $IP"
      until ping_check "$IP"; do
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] $IP unreachable, retrying in 5 seconds..."
        sleep 5
      done

      XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
      export XAUTHORITY="$XAUTH_FILE"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
      Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
      XVFB_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

      sleep 2

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
      xauth generate "$DISPLAY_NUM" . trusted
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

      export DISPLAY="$DISPLAY_NUM"
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
      vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
      VNC_PID=$!
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

      sleep 5

      retry_count=0
      echo "{\"status\":\"ok\",\"ip\":\"$IP\",\"message\":\"streaming\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
      ffmpeg -hide_banner -loglevel info \
        -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY" \
        -vaapi_device "$VAAPI_DEVICE" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
        -hls_time 4 \
        -hls_list_size 43200 \
        -hls_flags append_list \
        -strftime 1 \
        -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
        "$HLS_PLAYLIST"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"
      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))
      echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300
        retry_count=0
        echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date '+%Y-%m-%d %H:%M:%S')\"}" > "$STATUS_FILE"
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Restarting retries for lane $LANE_NUM."
      else
        backoff=$((RETRY_DELAY * retry_count))
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Waiting $backoff seconds before next retry on lane $LANE_NUM"
        sleep $backoff
      fi
    } >> "$LOG_FILE" 2>&1
  done
}

# Start all lanes in background
for i in "${!IPS[@]}"; do
  run_lane "${IPS[$i]}" "${DISPLAYS[$i]}" "$((i + 1))" &
done

wait
EOF

chmod +x ~/vnc-to-hls.sh
sudo reboot
pgrep -af archive.py
pyhton3 archive.py
python3 archive.py
tmux new -s archiver
cat archive.py
nano test.html
ls
mv test.html /vnc-hls/test2.html
cd vnc-hls
nano dl.html
ls
cd archive
ls
cd lane1
ls
cd ..
nano dl2.html
ls
cd archive
ls
cd lane2
ls
sudo lsof -i :5000
curl http://localhost:5000/archive/lane1/available
curl -I http://localhost:5000/archive/lane1/20250531-231157
cd ..
nano dl3.html
ls
cd archive
ls
cd ..
cat archive.py
cd ..
ls
cat archive.py
cat > /home/user/vnc-hls/archive.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Archived Clips</title>
  <style>
    body { font-family: sans-serif; background: #111; color: #fff; padding: 2em; }
    select, button { padding: 0.5em; font-size: 1em; }
    ul { list-style: none; padding: 0; }
    li { margin: 0.5em 0; }
    a { color: #4cf; text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <h1>Archived Clips</h1>
  <label for="laneSelect">Select lane:</label>
  <select id="laneSelect">
    <option value="lane1">lane1</option>
    <option value="lane2">lane2</option>
    <option value="lane3">lane3</option>
    <option value="lane4">lane4</option>
  </select>
  <button onclick="loadClips()">Load Clips</button>
  <ul id="clipList"></ul>

  <script>
    async function loadClips() {
      const lane = document.getElementById("laneSelect").value;
      const list = document.getElementById("clipList");
      list.innerHTML = "<li>Loading...</li>";
      try {
        const res = await fetch(`/archive/${lane}/`);
        const text = await res.text();
        const matches = [...text.matchAll(/href="([^"]+\.mp4)"/g)].map(m => m[1]);
        if (!matches.length) {
          list.innerHTML = "<li>No clips found.</li>";
        } else {
          list.innerHTML = "";
          matches.forEach(file => {
            const item = document.createElement("li");
            const link = document.createElement("a");
            link.href = `/archive/${lane}/${file}`;
            link.textContent = file;
            link.download = file;
            item.appendChild(link);
            list.appendChild(item);
          });
        }
      } catch (err) {
        list.innerHTML = "<li>Failed to fetch clips.</li>";
      }
    }
  </script>
</body>
</html>
EOF

ls
cd vnc-hls
ls
cat dl3.html
nano 666.html
cd ..
cd.
cd ..
ls
cd etc
ls
cd nginx
ls
nano nginx.conf
cdcdcd ..
cd ..
ls
cd home
cd user
ls
rm nohup.out
cd vnc-hls
ls
cd archive
ls
cd ..
cat dl3.html
nano d4.html
ls
cd ..
ls
nano archive_status.py
python3 archive_status.py
sudo lsof -i :5000
python3 archive_status.py --port 5001
kill 1677
sudo lsof -i :5000
python3 archive_status.py --port 5001
tmux new -s archive_status
nano d5.html
cd vnc-hls
nano d5.html
ls
curl -i http://localhost:5000/archive/lane2/available
nano d6.html
curl -i http://localhost:5000/archive/lane2/available
ls
cd ..
ls
cat archive_status.html
cat archive_status.py
curl -i http://localhost:5000/archive/lane2/available
ls
rm archive_status.py
nano archive_status.py
# Stop the current Flask process (Ctrl+C)
python3 archive_status.py
tmux 
tmux --help
ps
ps aux
kill 2132
ps aux
ls
python3 archive_status.py
tmux new -s status
ls
cd vnc-hls
ls
curl -i http://localhost:5000/archive/lane2/available
date
user@vnctranscoder:~/vnc-hls$ date
Sun Jun  1 01:56:44 AM UTC 2025
user@vnctranscoder:~/vnc-hls$sudo timedatectl set-timezone America/New_York
sudo timedatectl set-timezone America/New_York
date
cat dl3.html
cat > dl3.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VNC Archive Downloader</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 1em auto; }
    label { display: block; margin-top: 1em; }
    button { margin-top: 1em; }
    #clipsList { margin-top: 1em; max-height: 200px; overflow-y: auto; border: 1px solid #ccc; padding: 0.5em; }
    .clipItem { font-family: monospace; margin-bottom: 0.25em; }
    #status { margin-top: 1em; color: green; }
    #error { margin-top: 1em; color: red; }
  </style>
</head>
<body>

<h1>VNC Archive Downloader</h1>

<label for="laneSelect">Select Lane:</label>
<select id="laneSelect">
  <option value="lane1">lane1</option>
  <option value="lane2">lane2</option>
  <option value="lane3">lane3</option>
  <option value="lane4">lane4</option>
</select>

<label for="startTime">Start Time (UTC):</label>
<input type="datetime-local" id="startTime" />

<label for="endTime">End Time (UTC):</label>
<input type="datetime-local" id="endTime" />

<button id="fetchClipsBtn">Fetch Clips</button>

<div id="clipsList"></div>

<button id="downloadAllBtn" disabled>Download All Clips</button>

<div id="status"></div>
<div id="error"></div>

<script>
const SERVER_URL = 'http://localhost:5000';  // adjust if using remote server

function parseTimestamp(ts) {
  const dtStr = ts.replace(/^(\d{8})-(\d{6})$/, '$1T$2Z');
  return new Date(dtStr);
}

function formatTimestamp(ts) {
  const d = parseTimestamp(ts);
  return d.toUTCString();
}

function toDateTimeLocalInput(ts) {
  const year = ts.slice(0, 4);
  const month = ts.slice(4, 6);
  const day = ts.slice(6, 8);
  const hour = ts.slice(9, 11);
  const minute = ts.slice(11, 13);
  return `${year}-${month}-${day}T${hour}:${minute}`;
}

async function getAvailableClips(lane) {
  const res = await fetch(`${SERVER_URL}/archive/${lane}/available`);
  if (!res.ok) throw new Error('Failed to fetch available clips');
  return await res.json();
}

function filterClips(clips, start, end) {
  return clips.filter(ts => {
    const dt = parseTimestamp(ts);
    return dt >= start && dt <= end;
  });
}

async function downloadClip(lane, ts) {
  const url = `${SERVER_URL}/archive/${lane}/${ts}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to download clip ${ts}`);
  const blob = await res.blob();
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${lane}_${ts}.mp4`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(a.href);
}

async function updateTimeInputsForLane(lane) {
  try {
    const clips = await getAvailableClips(lane);
    if (clips.length === 0) {
      startTimeInput.value = '';
      endTimeInput.value = '';
      statusDiv.textContent = 'No clips available for this lane.';
      return;
    }

    const earliest = clips[0];
    const latest = clips[clips.length - 1];

    startTimeInput.value = toDateTimeLocalInput(earliest);
    endTimeInput.value = toDateTimeLocalInput(latest);

    const formatForDisplay = ts => {
      const d = parseTimestamp(ts);
      return d.toLocaleString(undefined, {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
      });
    };

    statusDiv.textContent = `Clips available from ${formatForDisplay(earliest)} to ${formatForDisplay(latest)}`;
    errorDiv.textContent = '';
  } catch (err) {
    errorDiv.textContent = `Error loading ${lane}: ${err.message}`;
  }
}

const laneSelect = document.getElementById('laneSelect');
const startTimeInput = document.getElementById('startTime');
const endTimeInput = document.getElementById('endTime');
const fetchClipsBtn = document.getElementById('fetchClipsBtn');
const clipsListDiv = document.getElementById('clipsList');
const downloadAllBtn = document.getElementById('downloadAllBtn');
const statusDiv = document.getElementById('status');
const errorDiv = document.getElementById('error');

let filteredClips = [];
let currentLane = '';

laneSelect.addEventListener('change', () => {
  updateTimeInputsForLane(laneSelect.value);
});

window.addEventListener('DOMContentLoaded', () => {
  updateTimeInputsForLane(laneSelect.value);
});

fetchClipsBtn.addEventListener('click', async () => {
  errorDiv.textContent = '';
  statusDiv.textContent = '';
  clipsListDiv.innerHTML = '';
  downloadAllBtn.disabled = true;

  const lane = laneSelect.value;
  currentLane = lane;
  const startStr = startTimeInput.value;
  const endStr = endTimeInput.value;

  if (!startStr || !endStr) {
    errorDiv.textContent = 'Please select both start and end times.';
    return;
  }

  const start = new Date(startStr);
  const end = new Date(endStr);
  if (start >= end) {
    errorDiv.textContent = 'Start time must be before end time.';
    return;
  }

  statusDiv.textContent = 'Fetching available clips...';

  try {
    const clips = await getAvailableClips(lane);
    filteredClips = filterClips(clips, start, end);
    if (filteredClips.length === 0) {
      statusDiv.textContent = 'No clips found in that time range.';
      return;
    }

    statusDiv.textContent = `Found ${filteredClips.length} clips.`;
    clipsListDiv.innerHTML = '';
    filteredClips.forEach(ts => {
      const div = document.createElement('div');
      div.className = 'clipItem';
      div.textContent = `${ts}  (${formatTimestamp(ts)})`;
      clipsListDiv.appendChild(div);
    });

    downloadAllBtn.disabled = false;
  } catch (err) {
    errorDiv.textContent = err.message;
  }
});

downloadAllBtn.addEventListener('click', async () => {
  if (!filteredClips.length || !currentLane) return;

  downloadAllBtn.disabled = true;
  statusDiv.textContent = `Downloading ${filteredClips.length} clips...`;
  errorDiv.textContent = '';

  for (let i = 0; i < filteredClips.length; i++) {
    const ts = filteredClips[i];
    try {
      statusDiv.textContent = `Downloading clip ${i+1} of ${filteredClips.length}: ${ts}`;
      await downloadClip(currentLane, ts);
    } catch (err) {
      errorDiv.textContent = `Error downloading clip ${ts}: ${err.message}`;
      break;
    }
  }

  statusDiv.textContent = 'Download complete.';
  downloadAllBtn.disabled = false;
});
</script>

</body>
</html>
EOF

cat > dl3.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VNC Archive Downloader</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 1em auto; }
    label { display: block; margin-top: 1em; }
    button { margin-top: 1em; }
    #clipsList { margin-top: 1em; max-height: 200px; overflow-y: auto; border: 1px solid #ccc; padding: 0.5em; }
    .clipItem { font-family: monospace; margin-bottom: 0.25em; }
    #status { margin-top: 1em; color: green; }
    #error { margin-top: 1em; color: red; }
  </style>
</head>
<body>

<h1>VNC Archive Downloader</h1>

<label for="laneSelect">Select Lane:</label>
<select id="laneSelect">
  <option value="lane1">Lane 1</option>
  <option value="lane2">Lane 2</option>
  <option value="lane3">lane3</option>
  <option value="lane4">lane4</option>
</select>

<label for="startTime">Start Time (UTC):</label>
<input type="datetime-local" id="startTime" />

<label for="endTime">End Time (UTC):</label>
<input type="datetime-local" id="endTime" />

<button id="fetchClipsBtn">Fetch Clips</button>

<div id="clipsList"></div>

<button id="downloadAllBtn" disabled>Download All Clips</button>

<div id="status"></div>
<div id="error"></div>

<script>
const SERVER_URL = 'http://localhost:5000';  // adjust if using remote server

function parseTimestamp(ts) {
  const dtStr = ts.replace(/^(\d{8})-(\d{6})$/, '$1T$2Z');
  return new Date(dtStr);
}

function formatTimestamp(ts) {
  const d = parseTimestamp(ts);
  return d.toUTCString();
}

function toDateTimeLocalInput(ts) {
  const year = ts.slice(0, 4);
  const month = ts.slice(4, 6);
  const day = ts.slice(6, 8);
  const hour = ts.slice(9, 11);
  const minute = ts.slice(11, 13);
  return `${year}-${month}-${day}T${hour}:${minute}`;
}

async function getAvailableClips(lane) {
  const res = await fetch(`${SERVER_URL}/archive/${lane}/available`);
  if (!res.ok) throw new Error('Failed to fetch available clips');
  return await res.json();
}

function filterClips(clips, start, end) {
  return clips.filter(ts => {
    const dt = parseTimestamp(ts);
    return dt >= start && dt <= end;
  });
}

async function downloadClip(lane, ts) {
  const url = `${SERVER_URL}/archive/${lane}/${ts}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to download clip ${ts}`);
  const blob = await res.blob();
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${lane}_${ts}.mp4`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(a.href);
}

async function updateTimeInputsForLane(lane) {
  try {
    const clips = await getAvailableClips(lane);
    if (clips.length === 0) {
      startTimeInput.value = '';
      endTimeInput.value = '';
      statusDiv.textContent = 'No clips available for this lane.';
      return;
    }

    const earliest = clips[0];
    const latest = clips[clips.length - 1];

    startTimeInput.value = toDateTimeLocalInput(earliest);
    endTimeInput.value = toDateTimeLocalInput(latest);

    const formatForDisplay = ts => {
      const d = parseTimestamp(ts);
      return d.toLocaleString(undefined, {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
      });
    };

    statusDiv.textContent = `Clips available from ${formatForDisplay(earliest)} to ${formatForDisplay(latest)}`;
    errorDiv.textContent = '';
  } catch (err) {
    errorDiv.textContent = `Error loading ${lane}: ${err.message}`;
  }
}

const laneSelect = document.getElementById('laneSelect');
const startTimeInput = document.getElementById('startTime');
const endTimeInput = document.getElementById('endTime');
const fetchClipsBtn = document.getElementById('fetchClipsBtn');
const clipsListDiv = document.getElementById('clipsList');
const downloadAllBtn = document.getElementById('downloadAllBtn');
const statusDiv = document.getElementById('status');
const errorDiv = document.getElementById('error');

let filteredClips = [];
let currentLane = '';

laneSelect.addEventListener('change', () => {
  updateTimeInputsForLane(laneSelect.value);
});

window.addEventListener('DOMContentLoaded', () => {
  updateTimeInputsForLane(laneSelect.value);
});

fetchClipsBtn.addEventListener('click', async () => {
  errorDiv.textContent = '';
  statusDiv.textContent = '';
  clipsListDiv.innerHTML = '';
  downloadAllBtn.disabled = true;

  const lane = laneSelect.value;
  currentLane = lane;
  const startStr = startTimeInput.value;
  const endStr = endTimeInput.value;

  if (!startStr || !endStr) {
    errorDiv.textContent = 'Please select both start and end times.';
    return;
  }

  const start = new Date(startStr);
  const end = new Date(endStr);
  if (start >= end) {
    errorDiv.textContent = 'Start time must be before end time.';
    return;
  }

  statusDiv.textContent = 'Fetching available clips...';

  try {
    const clips = await getAvailableClips(lane);
    filteredClips = filterClips(clips, start, end);
    if (filteredClips.length === 0) {
      statusDiv.textContent = 'No clips found in that time range.';
      return;
    }

    statusDiv.textContent = `Found ${filteredClips.length} clips.`;
    clipsListDiv.innerHTML = '';
    filteredClips.forEach(ts => {
      const div = document.createElement('div');
      div.className = 'clipItem';
      div.textContent = `${ts}  (${formatTimestamp(ts)})`;
      clipsListDiv.appendChild(div);
    });

    downloadAllBtn.disabled = false;
  } catch (err) {
    errorDiv.textContent = err.message;
  }
});

downloadAllBtn.addEventListener('click', async () => {
  if (!filteredClips.length || !currentLane) return;

  downloadAllBtn.disabled = true;
  statusDiv.textContent = `Downloading ${filteredClips.length} clips...`;
  errorDiv.textContent = '';

  for (let i = 0; i < filteredClips.length; i++) {
    const ts = filteredClips[i];
    try {
      statusDiv.textContent = `Downloading clip ${i+1} of ${filteredClips.length}: ${ts}`;
      await downloadClip(currentLane, ts);
    } catch (err) {
      errorDiv.textContent = `Error downloading clip ${ts}: ${err.message}`;
      break;
    }
  }

  statusDiv.textContent = 'Download complete.';
  downloadAllBtn.disabled = false;
});
</script>

</body>
</html>
EOF

cat > dl3.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VNC Archive Downloader</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 1em auto; }
    label { display: block; margin-top: 1em; }
    button { margin-top: 1em; }
    #clipsList { margin-top: 1em; max-height: 200px; overflow-y: auto; border: 1px solid #ccc; padding: 0.5em; }
    .clipItem { font-family: monospace; margin-bottom: 0.25em; }
    #status { margin-top: 1em; color: green; }
    #error { margin-top: 1em; color: red; }
  </style>
</head>
<body>

<h1>VNC Archive Downloader</h1>

<label for="laneSelect">Select Lane:</label>
<select id="laneSelect">
  <option value="lane1">Lane 1</option>
  <option value="lane2">Lane 2</option>
  <option value="lane3">lane3</option>
  <option value="lane4">lane4</option>
</select>

<label for="startTime">Start Time (UTC):</label>
<input type="datetime-local" id="startTime" />

<label for="endTime">End Time (UTC):</label>
<input type="datetime-local" id="endTime" />

<button id="fetchClipsBtn">Fetch Clips</button>

<div id="clipsList"></div>

<button id="downloadAllBtn" disabled>Download All Clips</button>

<div id="status"></div>
<div id="error"></div>

<script>
const SERVER_URL = 'http://localhost:5000';  // adjust if using remote server

function parseTimestamp(ts) {
  const dtStr = ts.replace(/^(\d{8})-(\d{6})$/, '$1T$2Z');
  return new Date(dtStr);
}

function formatTimestamp(ts) {
  const d = parseTimestamp(ts);
  return d.toUTCString();
}

function toDateTimeLocalInput(ts) {
  const year = ts.slice(0, 4);
  const month = ts.slice(4, 6);
  const day = ts.slice(6, 8);
  const hour = ts.slice(9, 11);
  const minute = ts.slice(11, 13);
  return `${year}-${month}-${day}T${hour}:${minute}`;
}

async function getAvailableClips(lane) {
  const res = await fetch(`${SERVER_URL}/archive/${lane}/available`);
  if (!res.ok) throw new Error('Failed to fetch available clips');
  return await res.json();
}

function filterClips(clips, start, end) {
  return clips.filter(ts => {
    const dt = parseTimestamp(ts);
    return dt >= start && dt <= end;
  });
}

async function downloadClip(lane, ts) {
  const url = `${SERVER_URL}/archive/${lane}/${ts}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to download clip ${ts}`);
  const blob = await res.blob();
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${lane}_${ts}.mp4`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(a.href);
}

async function updateTimeInputsForLane(lane) {
  try {
    const clips = await getAvailableClips(lane);
    if (clips.length === 0) {
      startTimeInput.value = '';
      endTimeInput.value = '';
      statusDiv.textContent = 'No clips available for this lane.';
      return;
    }

    const earliest = clips[0];
    const latest = clips[clips.length - 1];

    startTimeInput.value = toDateTimeLocalInput(earliest);
    endTimeInput.value = toDateTimeLocalInput(latest);

    const formatForDisplay = ts => {
      const d = parseTimestamp(ts);
      return d.toLocaleString(undefined, {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
      });
    };

    statusDiv.textContent = `Clips available from ${formatForDisplay(earliest)} to ${formatForDisplay(latest)}`;
    errorDiv.textContent = '';
  } catch (err) {
    errorDiv.textContent = `Error loading ${lane}: ${err.message}`;
  }
}

const laneSelect = document.getElementById('laneSelect');
const startTimeInput = document.getElementById('startTime');
const endTimeInput = document.getElementById('endTime');
const fetchClipsBtn = document.getElementById('fetchClipsBtn');
const clipsListDiv = document.getElementById('clipsList');
const downloadAllBtn = document.getElementById('downloadAllBtn');
const statusDiv = document.getElementById('status');
const errorDiv = document.getElementById('error');

let filteredClips = [];
let currentLane = '';

laneSelect.addEventListener('change', () => {
  updateTimeInputsForLane(laneSelect.value);
});

window.addEventListener('DOMContentLoaded', () => {
  updateTimeInputsForLane(laneSelect.value);
});

fetchClipsBtn.addEventListener('click', async () => {
  errorDiv.textContent = '';
  statusDiv.textContent = '';
  clipsListDiv.innerHTML = '';
  downloadAllBtn.disabled = true;

  const lane = laneSelect.value;
  currentLane = lane;
  const startStr = startTimeInput.value;
  const endStr = endTimeInput.value;

  if (!startStr || !endStr) {
    errorDiv.textContent = 'Please select both start and end times.';
    return;
  }

  const start = new Date(startStr);
  const end = new Date(endStr);
  if (start >= end) {
    errorDiv.textContent = 'Start time must be before end time.';
    return;
  }

  statusDiv.textContent = 'Fetching available clips...';

  try {
    const clips = await getAvailableClips(lane);
    filteredClips = filterClips(clips, start, end);
    if (filteredClips.length === 0) {
      statusDiv.textContent = 'No clips found in that time range.';
      return;
    }

    statusDiv.textContent = `Found ${filteredClips.length} clips.`;
    clipsListDiv.innerHTML = '';
    filteredClips.forEach(ts => {
      const div = document.createElement('div');
      div.className = 'clipItem';
      div.textContent = `${ts}  (${formatTimestamp(ts)})`;
      clipsListDiv.appendChild(div);
    });

    downloadAllBtn.disabled = false;
  } catch (err) {
    errorDiv.textContent = err.message;
  }
});

downloadAllBtn.addEventListener('click', async () => {
  if (!filteredClips.length || !currentLane) return;

  downloadAllBtn.disabled = true;
  statusDiv.textContent = `Downloading ${filteredClips.length} clips...`;
  errorDiv.textContent = '';

  for (let i = 0; i < filteredClips.length; i++) {
    const ts = filteredClips[i];
    try {
      statusDiv.textContent = `Downloading clip ${i+1} of ${filteredClips.length}: ${ts}`;
      await downloadClip(currentLane, ts);
    } catch (err) {
      errorDiv.textContent = `Error downloading clip ${ts}: ${err.message}`;
      break;
    }
  }

  statusDiv.textContent = 'Download complete.';
  downloadAllBtn.disabled = false;
});
</script>

</body>
</html>
EOF

nano config.json
cat > dl3.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VNC Archive Downloader</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 1em auto; }
    label { display: block; margin-top: 1em; }
    button { margin-top: 1em; }
    #clipsList { margin-top: 1em; max-height: 200px; overflow-y: auto; border: 1px solid #ccc; padding: 0.5em; }
    .clipItem { font-family: monospace; margin-bottom: 0.25em; }
    #status { margin-top: 1em; color: green; }
    #error { margin-top: 1em; color: red; }
  </style>
</head>
<body>

<h1>VNC Archive Downloader</h1>

<label for="laneSelect">Select Lane:</label>
<select id="laneSelect">
  <option value="lane1">lane1</option>
  <option value="lane2">lane2</option>
  <option value="lane3">lane3</option>
  <option value="lane4">lane4</option>
</select>

<label for="startTime">Start Time (UTC):</label>
<input type="datetime-local" id="startTime" />

<label for="endTime">End Time (UTC):</label>
<input type="datetime-local" id="endTime" />

<button id="fetchClipsBtn">Fetch Clips</button>

<div id="clipsList"></div>

<button id="downloadAllBtn" disabled>Download All Clips</button>

<div id="status"></div>
<div id="error"></div>

<script>
// Global config variable
let SERVER_URL = '';

async function loadConfig() {
  try {
    const res = await fetch('config.json');
    if (!res.ok) throw new Error('Failed to load config.json');
    const config = await res.json();
    SERVER_URL = config.server_url;
  } catch (err) {
    document.getElementById('error').textContent = `Config load error: ${err.message}`;
  }
}

function parseTimestamp(ts) {
  const dtStr = ts.replace(/^(\d{8})-(\d{6})$/, '$1T$2Z');
  return new Date(dtStr);
}

function formatTimestamp(ts) {
  const d = parseTimestamp(ts);
  return d.toUTCString();
}

function toDateTimeLocalInput(ts) {
  const year = ts.slice(0, 4);
  const month = ts.slice(4, 6);
  const day = ts.slice(6, 8);
  const hour = ts.slice(9, 11);
  const minute = ts.slice(11, 13);
  return `${year}-${month}-${day}T${hour}:${minute}`;
}

async function getAvailableClips(lane) {
  const res = await fetch(`${SERVER_URL}/archive/${lane}/available`);
  if (!res.ok) throw new Error('Failed to fetch available clips');
  return await res.json();
}

function filterClips(clips, start, end) {
  return clips.filter(ts => {
    const dt = parseTimestamp(ts);
    return dt >= start && dt <= end;
  });
}

async function downloadClip(lane, ts) {
  const url = `${SERVER_URL}/archive/${lane}/${ts}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to download clip ${ts}`);
  const blob = await res.blob();
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${lane}_${ts}.mp4`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(a.href);
}

async function updateTimeInputsForLane(lane) {
  try {
    const clips = await getAvailableClips(lane);
    if (clips.length === 0) {
      startTimeInput.value = '';
      endTimeInput.value = '';
      statusDiv.textContent = 'No clips available for this lane.';
      return;
    }

    const earliest = clips[0];
    const latest = clips[clips.length - 1];

    startTimeInput.value = toDateTimeLocalInput(earliest);
    endTimeInput.value = toDateTimeLocalInput(latest);

    const formatForDisplay = ts => {
      const d = parseTimestamp(ts);
      return d.toLocaleString(undefined, {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
      });
    };

    statusDiv.textContent = `Clips available from ${formatForDisplay(earliest)} to ${formatForDisplay(latest)}`;
    errorDiv.textContent = '';
  } catch (err) {
    errorDiv.textContent = `Error loading ${lane}: ${err.message}`;
  }
}

const laneSelect = document.getElementById('laneSelect');
const startTimeInput = document.getElementById('startTime');
const endTimeInput = document.getElementById('endTime');
const fetchClipsBtn = document.getElementById('fetchClipsBtn');
const clipsListDiv = document.getElementById('clipsList');
const downloadAllBtn = document.getElementById('downloadAllBtn');
const statusDiv = document.getElementById('status');
const errorDiv = document.getElementById('error');

let filteredClips = [];
let currentLane = '';

laneSelect.addEventListener('change', () => {
  updateTimeInputsForLane(laneSelect.value);
});

window.addEventListener('DOMContentLoaded', async () => {
  await loadConfig();
  if (SERVER_URL) {
    updateTimeInputsForLane(laneSelect.value);
  }
});

fetchClipsBtn.addEventListener('click', async () => {
  errorDiv.textContent = '';
  statusDiv.textContent = '';
  clipsListDiv.innerHTML = '';
  downloadAllBtn.disabled = true;

  if (!SERVER_URL) {
    errorDiv.textContent = 'Server URL is not configured.';
    return;
  }

  const lane = laneSelect.value;
  currentLane = lane;
  const startStr = startTimeInput.value;
  const endStr = endTimeInput.value;

  if (!startStr || !endStr) {
    errorDiv.textContent = 'Please select both start and end times.';
    return;
  }

  const start = new Date(startStr);
  const end = new Date(endStr);
  if (start >= end) {
    errorDiv.textContent = 'Start time must be before end time.';
    return;
  }

  statusDiv.textContent = 'Fetching available clips...';

  try {
    const clips = await getAvailableClips(lane);
    filteredClips = filterClips(clips, start, end);
    if (filteredClips.length === 0) {
      statusDiv.textContent = 'No clips found in that time range.';
      return;
    }

    statusDiv.textContent = `Found ${filteredClips.length} clips.`;
    clipsListDiv.innerHTML = '';
    filteredClips.forEach(ts => {
      const div = document.createElement('div');
      div.className = 'clipItem';
      div.textContent = `${ts}  (${formatTimestamp(ts)})`;
      clipsListDiv.appendChild(div);
    });

    downloadAllBtn.disabled = false;
  } catch (err) {
    errorDiv.textContent = err.message;
  }
});

downloadAllBtn.addEventListener('click', async () => {
  if (!filteredClips.length || !currentLane) return;

  downloadAllBtn.disabled = true;
  statusDiv.textContent = `Downloading ${filteredClips.length} clips...`;
  errorDiv.textContent = '';

  for (let i = 0; i < filteredClips.length; i++) {
    const ts = filteredClips[i];
    try {
      statusDiv.textContent = `Downloading clip ${i+1} of ${filteredClips.length}: ${ts}`;
      await downloadClip(currentLane, ts);
    } catch (err) {
      errorDiv.textContent = `Error downloading clip ${ts}: ${err.message}`;
      break;
    }
  }

  statusDiv.textContent = 'Download complete.';
  downloadAllBtn.disabled = false;
});
</script>

</body>
</html>
EOF

curl -i http://localhost:5000/archive/lane2/available
curl -i http://192.168.1.11:5000/archive/lane2/available
nano d7.html
ls
nano config.json
nano d8.html
pip install flask-cors
sudo apt update
ls
cd ..
ls
cat archive_status.py
rm archive_status.py
nano archive_status.py
ls
pkill -f archive_status.py
python3 archive_status.py &
sudo apt update
tmux attach -t status
cat d8.html
cd vnc-hls
cat d8.html
cat index.html
nano beta.html
nano beta2.html
cat beta2.html
ls
nano d9.html
ls
cat index.html
ps aux
tmux attach -s archiver
tmux attach -t archiver
python3 archive.py
cat archive_status.py
exit
ls
cd vnc-hls
ls
nano config.json
cd archive
ls
cd lane1
ls
python3 archive_status.py
cat archive_status.py
exit
python3 archive.py
ps ls
ps aux
systemctl
python3 archive_status.py
python3 archive.py
tmux new -s archiver
tmux new -s archive_status
cat archive_status.py
cat > archive_status.py << 'EOF'
from flask import Flask, send_from_directory, jsonify, abort
from flask_cors import CORS
import os
from datetime import datetime

app = Flask(__name__, static_folder='/home/user/vnc-hls', static_url_path='')
CORS(app)

ARCHIVE_ROOT = '/home/user/vnc-hls/archive'

@app.route('/')
def root():
    return app.send_static_file('dl3.html')

@app.route('/archive/<lane>/available')
def available_clips(lane):
    lane_dir = os.path.join(ARCHIVE_ROOT, lane)
    if not os.path.isdir(lane_dir):
        abort(404, description='Lane not found')

    clips = [f[:-4] for f in os.listdir(lane_dir) if f.endswith('.mp4')]
    clips.sort()

    date_range = None
    if clips:
        try:
            start_dt = datetime.strptime(clips[0], "%Y%m%d-%H%M%S")
            end_dt = datetime.strptime(clips[-1], "%Y%m%d-%H%M%S")
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
    filename = clip + '.mp4'
    if not os.path.isfile(os.path.join(lane_dir, filename)):
        abort(404, description='Clip not found')
    return send_from_directory(lane_dir, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
EOF

tmux attach -t archive_status
tmux ls
tmux new -s time
tmux ls
'



q
tmux ls
cat d8.html
cd vnc-hls
cat d8.html
nano d8.html
reboot
sudo reboot
python3 archive_status.py
ls
cd ..
python3 archive_status.py
nano archive_status.py
nano 
cd vnc-hls
nano config.json
cat config.json
cat d3.html
ls
cat dl3.html
cd ..
python3 archive_status.py
cat archive_status.py
xit
ls
cd ..
python3 archive.py
cat > archive.py << 'EOF'
import os
import subprocess
import time
from datetime import datetime, timezone
from flask import Flask, send_file, jsonify
from flask_cors import CORS

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
    output_path = os.path.join(output_dir, f"{lane}_{timestamp_str}.mp4")

    # Create concat file for ffmpeg
    concat_file = f"/tmp/{lane}_concat.txt"
    with open(concat_file, "w") as f:
        for segment in segment_files:
            segment_path = os.path.join(HLS_DIR, lane, segment)
            f.write(f"file '{segment_path}'\n")

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
            lane_dir = os.path.join(HLS_DIR, lane)
            if not os.path.isdir(lane_dir):
                print(f"Lane directory missing: {lane_dir}")
                continue
            ts_files = sorted([f for f in os.listdir(lane_dir) if f.endswith(".ts")])
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
        f[len(lane)+1:-4]  # strip "lane_" prefix and ".mp4" suffix
        for f in os.listdir(lane_path)
        if f.endswith('.mp4') and f.startswith(f"{lane}_")
    ])
    return jsonify(clips)

@app.route('/archive/<lane>/<timestamp>')
def get_clip(lane, timestamp):
    filename = f"{lane}_{timestamp}.mp4"
    clip_path = os.path.join(ARCHIVE_DIR, lane, filename)
    if not os.path.isfile(clip_path):
        return "Not Found", 404
    return send_file(clip_path, as_attachment=True)

if __name__ == '__main__':
    import threading
    threading.Thread(target=archive_loop, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
EOF

python3 archive.py
cat > archive_status.py << 'EOF'
from flask import Flask, send_from_directory, jsonify, abort
from flask_cors import CORS
import os
from datetime import datetime

app = Flask(__name__, static_folder='/home/user/vnc-hls', static_url_path='')
CORS(app)

ARCHIVE_ROOT = '/home/user/vnc-hls/archive'

@app.route('/')
def root():
    return app.send_static_file('dl3.html')

@app.route('/archive/<lane>/available')
def available_clips(lane):
    lane_dir = os.path.join(ARCHIVE_ROOT, lane)
    if not os.path.isdir(lane_dir):
        abort(404, description='Lane not found')

    clips = []
    for f in os.listdir(lane_dir):
        if f.endswith('.mp4') and f.startswith(f"{lane}-"):
            # Strip lane prefix and extension
            clips.append(f[len(lane)+1:-4])
    clips.sort()

    date_range = None
    if clips:
        try:
            start_dt = datetime.strptime(clips[0], "%Y%m%d-%H%M%S")
            end_dt = datetime.strptime(clips[-1], "%Y%m%d-%H%M%S")
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
    filename = f"{lane}-{clip}.mp4"
    if not os.path.isfile(os.path.join(lane_dir, filename)):
        abort(404, description='Clip not found')
    return send_from_directory(lane_dir, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
EOF

python3 archive_status.py
cat archive_status.py
python3 archive_status.py
ls
rm archive.old
rm d5.html
cd vnc-hls
ls
rm 666.html
rm s.html
rm index2.html
rm index5.html
rm index6.html
rm indexHMM.html
rm index-new.html
rm index-old.html
ls
rm d4.html
rm d5.html
rm d666.html
rm d7.html
rm d8.html
rm d9.html
rm dl2.html
rm dl3.html
rm dl.html
rm fixed_dl3.html
ls
rm index99html
rm index99.html
rm d6.html
ls
rm beta.html
rm beta2.html
ls
git add .
cd ..
[200~cat > .gitignore << 'EOF'
# Ignore all .ts and .mp4 video files
*.ts
*.mp4
EOF

~
[200~cat > .gitignore << 'EOF'
# Ignore all .ts and .mp4 video files
*.ts
*.mp4
EOF

~cat > .gitignore << 'EOF'
# Ignore all .ts and .mp4 video files
*.ts
*.mp4
EOF

~cat > .gitignore << 'EOF'
# Ignore all .ts and .mp4 video files
*.ts
*.mp4
EOF

cat > .gitignore << 'EOF'
# Ignore all .ts and .mp4 video files
*.ts
*.mp4
EOF

git add .
git commit -m "progress"
git push
ls
rm test.html
rm *.old*
ls
rm vnc-to-hls-old.sh
ls
cd vnc-hls
nano index.html
nano search.html
git add .
git commit -m "more"
git push
cd ..
ls
cd vnc-hls
ls
rm archive.html
ls
rm archive_30min_blocks.py
ls
git add .
git commit -m "cleanup"
git push
ls
cd ..
ls
cd tempaltes
cd templates
ls
cd ..
rm -r templates
ls
echo "venv/" >> .gitignore
git add .
git commit -m "cleanup"
git push
tmux attach -t time
tmux
tmux killwindow
tmux kill-window
tmux ls
tmux kill-window
tmux ls
python3 archive.py
cat archive.py
cd vnc-hls
cd archice
cd archive
cd lane1
ls
cd ..
cd.
cd ..
rm archive.py
nano archive.py
python3 archive.py
cd vnc-hls
cd hls
ls
cd lane1
ls
cd ..
rm archive.py
nano archive.py
python3 archive.py
mv archive.py archive.old
nano archive.py
python3 archive.py
ls
cd vnc-hls
ls
rm -r venv
rm novnc
rm -r novnc
ls
cd stataus
cd status
ls
cd ..
rm -r status
ls
rm -r dev-scripts
df -h
./cleanup.sh
df -h
crontab -l
systemctl status cron
grep CRON /var/log/syslog
grep 'cleanup.sh' /var/log/syslog | grep CRON
tail -n 50 -f ~/vnc-hls/logs/cleanup.log
systemctl status cron
date
grep 'cleanup.sh' /var/log/syslog.1 | grep CRON
zgrep 'cleanup.sh' /var/log/syslog.*.gz | grep CRON
crontab -l
ls
lsblk
sudo vgdisplay ubuntu-vg
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
df -Th /
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
df -Th /
systemctl list-units --type=service
last reboot
tmux ls
ls
cd ..
ls
cd status
ls
cd ..
mv archive*.py start-novnc.sh vnc-to-hls.sh vnc-to-hls.sh.save vnc-to-hls.service status ~/vnc-hls/
ls
cd vnc-hls
ls
rm archive_30min_blocks.py
ls
chmod +x ~/vnc-hls/archive.py ~/vnc-hls/archive_status.py ~/vnc-hls/cleanup.sh
sudo nano /etc/systemd/system/archive.service
sudo nano /etc/systemd/system/archive_status.service
sudo nano /etc/systemd/system/cleanup.service
sudo systemctl daemon-reload
sudo systemctl enable archive.service
sudo systemctl enable archive_status.service
sudo systemctl enable cleanup.service
sudo reboot
df -h
systemctl status archive.service
systemctl list-units --type=service --state=running
sudo nano /etc/systemd/system/vnc-to-hls.service
sudo systemctl daemon-reload
sudo systemctl enable vnc-to-hls.service
sudo reboot
ls
rm 'ystemctl list-units --type=service --state=running'
ls
cd vnc-hls
ls
cd logs
ls
systemctl list-units --type=service --all
journalctl -u vnc-to-hls.service -f
cd ..
ls
./vnc-to-hls.sh
cd ..
git restore status
ls
cd vnc-hls
cd logs
ls
cd ..
./vnc-to-hls.sh
journalctl -u vnc-to-hls.service -f
systemctl list-units --type=service --all
sudo apt update
sudo apt install avahi-daemon
sudo systemctl enable avahi-daemon --now
sudo hostnamectl set-hostname dashboard
ping dashboard.local
systemctl status avahi-daemon
hostname
avahi-browse -a
sudo apt install avahi-utils
avahi-browse -a
user@vnctranscoder:~/vnc-hls$ avahi-browse -a
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       UNIX Printer         local
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       Internet Printer     local
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       Secure Internet Printer local
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       PDL Printer          local
+ enp1s0 IPv6 FF28001235A109B0DF233921                      _spotify-connect._tcp local
+ enp1s0 IPv6 FF280012F2693D5A8E618568                      _spotify-connect._tcp local
+ enp1s0 IPv4 FF28001235A109B0DF233921                      _spotify-connect._tcp local
+ enp1s0 IPv4 FF280012F2693D5A8E618568                      _spotify-connect._tcp local
+ enp1s0 IPv6 Fireplace                                     Web Site             local
+ enp1s0 IPv6 Fireplace                                     AirPlay Remote Video local
+ enp1s0 IPv6 00226C012FBE@Fireplace                        AirTunes Remote Audio local
+ enp1s0 IPv6 Fireplace                                     _linkplay._tcp       local
+ enp1s0 IPv6 Brother MFC-J1010DW                           PDL Printer          local
+ enp1s0 IPv6 Brother MFC-J1010DW                           UNIX Printer         local
+ enp1s0 IPv6 Brother MFC-J1010DW                           Internet Printer     local
+ enp1s0 IPv6 Brother MFC-J1010DW                           _scanner._tcp        local
+ enp1s0 IPv6 Brother MFC-J1010DW                           Web Site             local
+ enp1s0 IPv6 Brother MFC-J1010DW                           _uscan._tcp          local
+ enp1s0 IPv4 Fireplace                                     Web Site             local
+ enp1s0 IPv4 Fireplace                                     AirPlay Remote Video local
+ enp1s0 IPv4 00226C012FBE@Fireplace                        AirTunes Remote Audio local
+ enp1s0 IPv4 Fireplace                                     _linkplay._tcp       local
+ enp1s0 IPv4 Brother MFC-J1010DW                           PDL Printer          local
+ enp1s0 IPv4 Brother MFC-J1010DW                           UNIX Printer         local
+ enp1s0 IPv4 Brother MFC-J1010DW                           Internet Printer     local
+ enp1s0 IPv4 Brother MFC-J1010DW                           _scanner._tcp        local
+ enp1s0 IPv4 Brother MFC-J1010DW                           Web Site             local
+ enp1s0 IPv4 Brother MFC-J1010DW                           _uscan._tcp          local
+ enp1s0 IPv4 921891618                                     _teamviewer._tcp     local
+ enp1s0 IPv4 1406044388                                    _teamviewer._tcp     local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    PDL Printer          local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    UNIX Printer         local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    Internet Printer     local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    _scanner._tcp        local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    Web Site             local
+ enp1s0 IPv4 Brother MFC-L2710DW series                    _uscan._tcp          local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    PDL Printer          local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    UNIX Printer         local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    Internet Printer     local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    _scanner._tcp        local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    Web Site             local
+ enp1s0 IPv6 Brother MFC-L2710DW series                    _uscan._tcp          local
+ enp1s0 IPv4 1288640429                                    _teamviewer._tcp     local
+ enp1s0 IPv4 1265466606                                    _teamviewer._tcp     local
+ enp1s0 IPv4 1628680260                                    _teamviewer._tcp     local
+ enp1s0 IPv4 1445490529                                    _teamviewer._tcp     local
+ enp1s0 IPv4 Brother MFC-L2690DW                           PDL Printer          local
+ enp1s0 IPv4 Brother MFC-L2690DW                           UNIX Printer         local
+ enp1s0 IPv4 Brother MFC-L2690DW                           Internet Printer     local
+ enp1s0 IPv4 Brother MFC-L2690DW                           _scanner._tcp        local
+ enp1s0 IPv4 Brother MFC-L2690DW                           Web Site             local
+ enp1s0 IPv4 Brother MFC-L2690DW                           _privet._tcp         local
+ enp1s0 IPv4 Brother MFC-L2690DW                           _uscan._tcp          local
+ enp1s0 IPv6 Brother MFC-L2690DW                           PDL Printer          local
+ enp1s0 IPv6 Brother MFC-L2690DW                           UNIX Printer         local
+ enp1s0 IPv6 Brother MFC-L2690DW                           Internet Printer     local
+ enp1s0 IPv6 Brother MFC-L2690DW                           _scanner._tcp        local
+ enp1s0 IPv6 Brother MFC-L2690DW                           Web Site             local
+ enp1s0 IPv6 Brother MFC-L2690DW                           _privet._tcp         local
+ enp1s0 IPv6 Brother MFC-L2690DW                           _uscan._tcp          local
+ enp1s0 IPv6 HP Color LaserJet Pro 3201 [AD3C4C]           PDL Printer          local
+ enp1s0 IPv6 HP Color LaserJet Pro 3201 [AD3C4C]           Web Site             local
+ enp1s0 IPv6 HP Color LaserJet Pro 3201 [AD3C4C]           _cdm._tcp            local
+ enp1s0 IPv6 HP Color LaserJet Pro 3201 [AD3C4C]           Internet Printer     local
+ enp1s0 IPv6 HP Color LaserJet Pro 3201 [AD3C4C]           Secure Internet Printer local
+ enp1s0 IPv4 HP Color LaserJet Pro 3201 [AD3C4C]           PDL Printer          local
+ enp1s0 IPv4 HP Color LaserJet Pro 3201 [AD3C4C]           Web Site             local
+ enp1s0 IPv4 HP Color LaserJet Pro 3201 [AD3C4C]           _cdm._tcp            local
+ enp1s0 IPv4 HP Color LaserJet Pro 3201 [AD3C4C]           Internet Printer     local
+ enp1s0 IPv4 HP Color LaserJet Pro 3201 [AD3C4C]           Secure Internet Printer local
+ enp1s0 IPv4 0                                             _teamviewer._tcp     local
+ enp1s0 IPv4 Brother MFC-J805DW                            PDL Printer          local
+ enp1s0 IPv4 Brother MFC-J805DW                            UNIX Printer         local
+ enp1s0 IPv4 Brother MFC-J805DW                            Internet Printer     local
+ enp1s0 IPv4 Brother MFC-J805DW                            _scanner._tcp        local
+ enp1s0 IPv4 Brother MFC-J805DW                            Web Site             local
+ enp1s0 IPv4 Brother MFC-J805DW                            _uscan._tcp          local
+ enp1s0 IPv6 Brother MFC-J805DW                            PDL Printer          local
+ enp1s0 IPv6 Brother MFC-J805DW                            UNIX Printer         local
+ enp1s0 IPv6 Brother MFC-J805DW                            Internet Printer     local
+ enp1s0 IPv6 Brother MFC-J805DW                            _scanner._tcp        local
+ enp1s0 IPv6 Brother MFC-J805DW                            Web Site             local
+ enp1s0 IPv6 Brother MFC-J805DW                            _uscan._tcp          local
+ enp1s0 IPv4 248248143                                     _teamviewer._tcp     local
+ enp1s0 IPv4 1346488388                                    _teamviewer._tcp     local
+ enp1s0 IPv4 Luke___s iPhone                               _rdlink._tcp         local
+ enp1s0 IPv6 Luke___s iPhone                               _rdlink._tcp         local
+ enp1s0 IPv4 SonosLibraryServer                            Web Site             local
+ enp1s0 IPv6 SonosLibraryServer                            Web Site             local
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       Web Site             local
+ enp1s0 IPv4 Kyocera ECOSYS M3540idn                       Secure Web Site      local
+ enp1s0 IPv6 D40f-J09-2b4f483a2be0499afc5daf409b12140a     _googlecast._tcp     local
+ enp1s0 IPv4 D40f-J09-2b4f483a2be0499afc5daf409b12140a     _googlecast._tcp     local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     PDL Printer          local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     UNIX Printer         local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     Internet Printer     local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     _scanner._tcp        local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     Web Site             local
+ enp1s0 IPv4 Brother MFC-L2710DW series [b422009d1da4]     _uscan._tcp          local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     PDL Printer          local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     UNIX Printer         local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     Internet Printer     local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     _scanner._tcp        local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     Web Site             local
+ enp1s0 IPv6 Brother MFC-L2710DW series [b422009d1da4]     _uscan._tcp          local
+ enp1s0 IPv4 Stairs                                        Web Site             local
+ enp1s0 IPv4 Stairs                                        AirPlay Remote Video local
+ enp1s0 IPv4 00226C25AD01@Stairs                           AirTunes Remote Audio local
+ enp1s0 IPv4 Stairs                                        _linkplay._tcp       local
+ enp1s0 IPv6 Stairs                                        Web Site             local
+ enp1s0 IPv6 Stairs                                        AirPlay Remote Video local
+ enp1s0 IPv6 00226C25AD01@Stairs                           AirTunes Remote Audio local
+ enp1s0 IPv6 Stairs                                        _linkplay._tcp       local
+ enp1s0 IPv4 Brother VC-500W 4890                          UNIX Printer         local
+ enp1s0 IPv4 Brother VC-500W 4890                          Secure Internet Printer local
+ enp1s0 IPv4 Brother VC-500W 4890                          Internet Printer     local
+ enp1s0 IPv4 Brother VC-500W 4890                          Web Site             local
+ enp1s0 IPv6 Brother VC-500W 4890                          UNIX Printer         local
+ enp1s0 IPv6 Brother VC-500W 4890                          Secure Internet Printer local
+ enp1s0 IPv6 Brother VC-500W 4890                          Internet Printer     local
+ enp1s0 IPv6 Brother VC-500W 4890                          Web Site             local
+ enp1s0 IPv4 OctoPrint instance on raspberrypi             Web Site             local
+ enp1s0 IPv4 Brother HL-L2350DW series                     PDL Printer          local
+ enp1s0 IPv4 Brother HL-L2350DW series                     UNIX Printer         local
+ enp1s0 IPv4 Brother HL-L2350DW series                     Internet Printer     local
+ enp1s0 IPv4 Brother HL-L2350DW series                     Web Site             local
+ enp1s0 IPv4 Brother HL-L2350DW series                     _privet._tcp         local
+ enp1s0 IPv6 Brother HL-L2350DW series                     PDL Printer          local
+ enp1s0 IPv6 Brother HL-L2350DW series                     UNIX Printer         local
+ enp1s0 IPv6 Brother HL-L2350DW series                     Internet Printer     local
+ enp1s0 IPv6 Brother HL-L2350DW series                     Web Site             local
+ enp1s0 IPv6 Brother HL-L2350DW series                     _privet._tcp         local
+ enp1s0 IPv6 lmh___s MacBook Pro                           _companion-link._tcp local
+ enp1s0 IPv4 lmh___s MacBook Pro                           _companion-link._tcp local
+ enp1s0 IPv6 VC-500W4890 [04:fe:a1:56:a6:ba]               Workstation          local
+ enp1s0 IPv4 VC-500W4890 [04:fe:a1:56:a6:ba]               Workstation          local
+ enp1s0 IPv4 OctoPrint instance on raspberrypi             _octoprint._tcp      local
+ enp1s0 IPv4 Canon MF440 Series                            _privet._tcp         local
+ enp1s0 IPv4 Canon MF440 Series                            _uscan._tcp          local
+ enp1s0 IPv4 Canon MF440 Series                            _scanner._tcp        local
+ enp1s0 IPv4 Canon MF440 Series                            PDL Printer          local
+ enp1s0 IPv4 Canon MF440 Series                            Secure Internet Printer local
+ enp1s0 IPv4 Canon MF440 Series                            Internet Printer     local
systemctl status avahi-daemon
ping dashboard-hostname.local
ping dashboard.local
hostname
hostname -I
sudo tee /etc/avahi/services/dashboard.service > /dev/null << 'EOF'
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">Dashboard on %h</name>
  <service>
    <type>_http._tcp</type>
    <port>80</port>
  </service>
</service-group>
EOF

ls
rm hboard-hostname.local
ls
sudo systemctl restart avahi-daemon
avahi-browse -a
