  }
  .container {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    align-items: center;
    height: 100vh;
    gap: 10px;
    padding: 10px;
  }
  video {
    width: 23%; /* Four videos in one row with some gap */
    height: auto;
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
  }
</style>
</head>
<body>

<div class="container">
  <video id="video11" controls muted autoplay></video>
  <video id="video12" controls muted autoplay></video>
  <video id="video13" controls muted autoplay></video>
  <video id="video14" controls muted autoplay></video>
</div>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);

    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = url;
      video.addEventListener('error', e => {
        console.error(`Native HLS error on ${id}`, e);
      });
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
      hls.on(Hls.Events.ERROR, function(event, data) {
        console.error(`hls.js error on ${id}`, data);
      });
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

exit
sudo tee /var/www/html/vnc1/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>VNC to HLS Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<style>
  body { background: #111; color: #eee; font-family: Arial, sans-serif; text-align: center; }
  video { max-width: 90vw; margin-top: 2rem; border: 2px solid #444; }
</style>
</head>
<body>
<h1>VNC to HLS Live Stream</h1>
<video id="video" controls autoplay muted></video>
<script>
  if(Hls.isSupported()) {
    var video = document.getElementById('video');
    var hls = new Hls();
    hls.loadSource('stream.m3u8');
    hls.attachMedia(video);
    hls.on(Hls.Events.MANIFEST_PARSED,function() {
      video.play();
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    video.src = 'stream.m3u8';
    video.addEventListener('loadedmetadata',function() {
      video.play();
    });
  } else {
    document.body.innerHTML = "<p>Your browser does not support HLS playback.</p>";
  }
</script>
</body>
</html>
EOF

cat <<'EOF' > ~/vnc_to_hls.sh

#!/bin/bash

# Configuration
OUTPUT_DIR="/var/www/html/vnc1"
OUTPUT_FILE="stream.m3u8"
VNC_IP="192.168.4.101"
VNC_PASSWORD="wuotu1Iocheegi6u"
RESOLUTION="480x800"
FRAMERATE="10"

LOGFILE="/var/log/vnc_to_hls.log"

# Create output directory if missing
sudo mkdir -p "$OUTPUT_DIR"
sudo chown $USER:$USER "$OUTPUT_DIR"


# Export VNC password environment for ffmpeg
export LIBVNCV_PASSWORD="$VNC_PASSWORD"

# Check for VAAPI hardware acceleration device
if [ -e /dev/dri/renderD128 ]; then
    echo "[INFO] VAAPI device found. Using hardware acceleration." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f vnc -i "$VNC_IP:0" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -r $FRAMERATE -s $RESOLUTION \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
else
    echo "[WARN] VAAPI device not found. Falling back to CPU encoding." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f vnc -i "$VNC_IP:0" \
        -r $FRAMERATE -s $RESOLUTION \
        -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
fi
EOF

chmod +x ~/vnc_to_hls.sh
sudo tee "$OUTPUT_DIR/index.html" > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>VNC to HLS Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<style>
  body { background: #111; color: #eee; font-family: Arial, sans-serif; text-align: center; }
  video { max-width: 90vw; margin-top: 2rem; border: 2px solid #444; }
</style>
</head>
<body>
<h1>VNC to HLS Live Stream</h1>
<video id="video" controls autoplay muted></video>
<script>
  if(Hls.isSupported()) {
    var video = document.getElementById('video');
    var hls = new Hls();
    hls.loadSource('stream.m3u8');
    hls.attachMedia(video);
    hls.on(Hls.Events.MANIFEST_PARSED,function() {
      video.play();
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    video.src = 'stream.m3u8';
    video.addEventListener('loadedmetadata',function() {
      video.play();
    });
  } else {
    document.body.innerHTML = "<p>Your browser does not support HLS playback.</p>";
  }
</script>
</body>
</html>
EOF

./vnc_to_hls.sh
user@vnctranscoder:~$ ./vnc_to_hls.sh
tee: /var/log/vnc_to_hls.log: Permission denied
[INFO] VAAPI device found. Using hardware acceleration.
tee: /var/log/vnc_to_hls.log: Permission denied
[in#0 @ 0x5650fd89b940] Unknown input format: 'vnc'
Error opening input file 192.168.4.101:0.
Error opening input files: Invalid argument
user@vnctranscoder:~$ 
sudo apt update
sudo apt install -y   autoconf automake build-essential cmake git libass-dev libfreetype6-dev libgnutls28-dev   libmp3lame-dev libnuma-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev   libxcb-shm0-dev libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev   libvncclient-dev libvncserver-dev
cd /tmp
git clone https://github.com/LibVNC/libvncserver.git
cd libvncserver
git checkout stable  # optional, or choose a stable tag like v0.9.13
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
cmake --build build
sudo cmake --install build
cd /tmp
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
# Optionally checkout a stable release tag, e.g.:
# git checkout n6.1
./configure   --prefix=/usr/local   --enable-gpl   --enable-libvncclient   --enable-libx264   --enable-vaapi   --enable-nonfree   --enable-shared
sudo apt install libvncclient-dev
cd /tmp
git clone https://github.com/LibVNC/libvncserver.git
cd libvncserver
# Checkout a stable release tag (optional)
git checkout stable
# Build using cmake
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
# Compile
cmake --build build
# Install libraries and headers system-wide
sudo cmake --install build
sudo rm -rf /tmp/libvncserver
cd /tmp
git clone https://github.com/LibVNC/libvncserver.git
cd libvncserver
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
cmake --build build -j$(nproc)
sudo cmake --install build
sudo rm -rf /tmp/ffmpeg
cd /tmp
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --prefix=/usr/local --enable-gpl --enable-libx264 --enable-libvncclient --enable-vaapi --enable-nonfree --enable-shared
make -j$(nproc)
sudo make install
hash -r
ffmpeg -protocols | grep vnc
/usr/local/bin/ffmpeg -protocols | grep vnc
make clean
ls
cd /tmp
rm -rf ffmpeg
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
# or
# git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
# Checkout a stable release tag if you want (optional)
# git checkout n6.1
# Configure with libvncclient support
./configure --prefix=/usr/local --enable-libvncclient --enable-gpl --enable-nonfree
make -j$(nproc)
sudo make install
sudo systemctl status nginc
sudo systemctl status nginx
sudo nano /etc/nginx/sites-available/default
sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        autoindex on;
        add_header Cache-Control no-cache;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
ip a | grep inet
sudo systemctl status nginx
sudo ss -tuln | grep :80
sudo nano /etc/nginx/sites-enabled/default
ls
cat <<'EOF' > /etc/nginx/sites-enabled/default

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /home/user/vnc-hls;
    index index.html;

    location /hls/ {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
        autoindex on;
    }
}


EOF

echo $HOME
sudo tee /etc/nginx/sites-enabled/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /home/vnctranscoder/vnc-hls;
    index index.html;

    location /hls/ {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
        autoindex on;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
mkdir -p /home/vnctranscoder/vnc-hls/js
cd /home/vnctranscoder/vnc-hls/js
wget https://cdn.jsdelivr.net/npm/hls.js@1.5.0/dist/hls.min.js
cat <<'EOF' > /home/vnctranscoder/vnc-hls/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>VNC HLS Test Viewer</title>
  <style>
    body { background: #000; margin: 0; display: flex; align-items: center; justify-content: center; height: 100vh; }
    video { width: 100%; max-width: 480px; height: auto; background: #000; }
  </style>
</head>
<body>
  <video id="video" controls autoplay muted></video>
  <script src="js/hls.min.js"></script>
  <script>
    const video = document.getElementById('video');
    const src = 'hls/lane1.m3u8';

    if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(src);
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED, function () {
        video.play();
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = src;
      video.addEventListener('loadedmetadata', function () {
        video.play();
      });
    } else {
      document.body.innerHTML = "<p style='color:white;'>HLS is not supported in this browser.</p>";
    }
  </script>
</body>
</html>
EOF

ls
cd ..
cat <<'EOF' > /home/vnctranscoder/vnc-hls/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>VNC HLS Test Viewer</title>
  <style>
    body { background: #000; margin: 0; display: flex; align-items: center; justify-content: center; height: 100vh; }
    video { width: 100%; max-width: 480px; height: auto; background: #000; }
  </style>
</head>
<body>
  <video id="video" controls autoplay muted></video>
  <script src="js/hls.min.js"></script>
  <script>
    const video = document.getElementById('video');
    const src = 'hls/lane1.m3u8';

    if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(src);
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED, function () {
        video.play();
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = src;
      video.addEventListener('loadedmetadata', function () {
        video.play();
      });
    } else {
      document.body.innerHTML = "<p style='color:white;'>HLS is not supported in this browser.</p>";
    }
  </script>
</body>
</html>
EOF

ls
cd home
ls
cd user
ls
cd vlc-hls
cd vnc-hls
ls
sudo bash -c 'cat <<EOF > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /home/user/vnc-hls;
    index index.html;

    location /hls/ {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
        autoindex on;
    }
}
EOF'
sudo systemctl reload nginx
sudo ss -tuln | grep :80
sudo chown -R www-data:www-data /home/user/vnc-hls/hls
sudo chmod -R 755 /home/user/vnc-hls/hls
sudo systemctl reload nginx
ps aux | grep nginx
namei -l /home/user/vnc-hls/hls
sudo chmod o+x /home/user
sudo systemctl reload nginx
sudo -u www-data ls /home/user/vnc-hls/hls
ls -l /home/user/vnc-hls/hls
sudo chmod -R o+r /home/user/vnc-hls/hls
sudo tee /etc/nginx/sites-enabled/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    # Main root (not used for /hls/)
    root /home/user/vnc-hls;
    index index.html;

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin "*";
        autoindex on;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
cat <<'EOF' > /home/user/vnc-hls/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Stream Viewer</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<style>
  body { margin: 0; background: #000; display: flex; justify-content: center; align-items: center; height: 100vh; }
  video { width: 90vw; height: 90vh; background: #000; }
</style>
</head>
<body>
<video id="video" controls autoplay muted></video>
<script>
  const video = document.getElementById('video');
  const videoSrc = '/hls/lane1.m3u8';

  if (Hls.isSupported()) {
    const hls = new Hls();
    hls.loadSource(videoSrc);
    hls.attachMedia(video);
    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      video.play();
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    // For Safari native HLS support
    video.src = videoSrc;
    video.addEventListener('loadedmetadata', () => {
      video.play();
    });
  } else {
    alert('Your browser does not support HLS playback.');
  }
</script>
</body>
</html>
EOF

sudo systemctl reload nginx
cat <<'EOF' > /home/user/vnc-hls/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>T-Bar Gates Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<style>
  body {
    margin: 0;
    background: #111;
    color: #eee;
    font-family: Arial, sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  h1 {
    margin: 1rem 0;
  }
  .dashboard {
    display: flex;
    flex-direction: row;
    justify-content: center;
    gap: 0.5rem;
    width: 95vw;
  }
  .feed {
    flex: 1 1 0;
    display: flex;
    flex-direction: column;
    background: #222;
    border-radius: 6px;
    padding: 0.5rem;
    box-sizing: border-box;
  }
  .feed video {
    width: 100%;
    height: auto;
    border-radius: 4px;
    background: black;
  }
  .feed label {
    margin-top: 0.5rem;
    text-align: center;
    font-weight: bold;
  }
  @media (max-width: 600px) {
    .dashboard {
      flex-direction: column;
      width: 100vw;
    }
    .feed {
      margin-bottom: 1rem;
    }
  }
</style>
</head>
<body>
  <h1>T-Bar Gates Dashboard</h1>
  <div class="dashboard">
    <div class="feed">
      <video id="video1" controls autoplay muted></video>
      <label>192.168.4.101 (Lane 1)</label>
    </div>
    <div class="feed">
      <video id="video2" controls autoplay muted></video>
      <label>192.168.4.102 (Lane 2)</label>
    </div>
    <div class="feed">
      <video id="video3" controls autoplay muted></video>
      <label>192.168.4.103 (Lane 3)</label>
    </div>
    <div class="feed">
      <video id="video4" controls autoplay muted></video>
      <label>192.168.4.104 (Lane 4)</label>
    </div>
  </div>

<script>
  const streams = [
    '/hls/lane1.m3u8',
    '/hls/lane2.m3u8',
    '/hls/lane3.m3u8',
    '/hls/lane4.m3u8',
  ];

  function setupHls(videoId, streamUrl) {
    const video = document.getElementById(videoId);
    if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(streamUrl);
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        video.play();
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = streamUrl;
      video.addEventListener('loadedmetadata', () => {
        video.play();
      });
    } else {
      console.warn('HLS not supported for', streamUrl);
    }
  }

  streams.forEach((url, i) => {
    setupHls('video' + (i + 1), url);
  });
</script>
</body>
</html>
EOF

sudo systemctl reload nginx
cat << 'EOF' > /home/user/vnc-hls/restart-vnc-to-hls.sh
#!/bin/bash
set -e

HLS_DIR="/home/user/vnc-hls/hls"
mkdir -p "$HLS_DIR"

echo "Killing old ffmpeg processes..."
pkill -f "ffmpeg.*lane" || true
sleep 1

echo "Starting new ffmpeg streams..."

for i in 1 2 3 4; do
  VNC_IP="192.168.4.10${i}"
  OUTPUT="${HLS_DIR}/lane${i}.m3u8"

  ffmpeg -loglevel info -y \
    -i "vnc://${VNC_IP}:5900" \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi \
    -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "${HLS_DIR}/lane${i}_%03d.ts" \
    "$OUTPUT" &

  echo "Started stream lane${i} from $VNC_IP"
done

echo "All streams started."
EOF

chmod +x /home/user/vnc-hls/restart-vnc-to-hls.sh
/home/user/vnc-hls/restart-vnc-to-hls.sh
cat << 'EOF' > /home/user/vnc-hls/restart-vnc-to-hls.sh
#!/bin/bash
set -e

HLS_DIR="/home/user/vnc-hls/hls"
mkdir -p "$HLS_DIR"

echo "Killing old ffmpeg and vncviewer processes..."
pkill -f "ffmpeg.*lane" || true
pkill -f "vncviewer.*lane" || true
sleep 2

for i in 1 2 3 4; do
  DISPLAY_NUM=$((100 + i))  # Avoid conflicts, use :101, :102, etc.
  export DISPLAY=:$DISPLAY_NUM
  XAUTH_FILE="/tmp/.Xauthority_lane${i}"
  export XAUTHORITY=$XAUTH_FILE

  # Create a new Xauthority file
  xauth -f "$XAUTH_FILE" generate $DISPLAY . trusted

  # Start TigerVNC viewer in view-only mode on a unique display
  vncviewer -ViewOnly=1 -FullScreen=1 192.168.4.10${i}:5900 -passwd ~/.vnc/passwd -display $DISPLAY &

  VNC_PID=$!
  echo "Started vncviewer lane${i} on DISPLAY $DISPLAY (PID $VNC_PID)"

  # Wait briefly for VNC viewer to initialize
  sleep 5

  # Run FFmpeg capturing the X11 display for lane i
  ffmpeg -loglevel info -y \
    -f x11grab -r 10 -s 480x800 -i $DISPLAY \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi \
    -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "${HLS_DIR}/lane${i}_%03d.ts" \
    "${HLS_DIR}/lane${i}.m3u8" &

  echo "Started ffmpeg lane${i}"
done

echo "All 4 streams started."
EOF

chmod +x /home/user/vnc-hls/restart-vnc-to-hls.sh
/home/user/vnc-hls/restart-vnc-to-hls.sh
cat << 'EOF' > /home/user/vnc-hls/restart-vnc-to-hls.sh
#!/bin/bash
set -e

HLS_DIR="/home/user/vnc-hls/hls"
mkdir -p "$HLS_DIR"

echo "Killing old ffmpeg, vncviewer and Xvfb processes..."
pkill -f "ffmpeg.*lane" || true
pkill -f "vncviewer.*lane" || true
pkill -f "Xvfb :10" || true
pkill -f "Xvfb :11" || true
pkill -f "Xvfb :12" || true
pkill -f "Xvfb :13" || true
sleep 2

for i in 1 2 3 4; do
  DISPLAY_NUM=$((10 + i))  # use :11, :12, :13, :14 (lower numbers)
  export DISPLAY=:$DISPLAY_NUM
  XAUTH_FILE="/tmp/.Xauthority_lane${i}"
  export XAUTHORITY=$XAUTH_FILE

  # Start Xvfb virtual display
  Xvfb $DISPLAY -screen 0 480x800x24 &

  XVFB_PID=$!
  echo "Started Xvfb for lane${i} on DISPLAY $DISPLAY (PID $XVFB_PID)"

  sleep 3  # give Xvfb time to start

  # Generate a new xauth cookie for this display
  xauth -f "$XAUTH_FILE" generate $DISPLAY . trusted

  # Start TigerVNC viewer inside the Xvfb display in view-only mode
  DISPLAY=$DISPLAY vncviewer -ViewOnly=1 192.168.4.10${i}:5900 -passwd ~/.vnc/passwd &

  VNC_PID=$!
  echo "Started vncviewer lane${i} on DISPLAY $DISPLAY (PID $VNC_PID)"

  sleep 5  # wait for VNC viewer to fully load

  # Run FFmpeg capturing the X11 virtual display for lane i
  ffmpeg -loglevel info -y \
    -f x11grab -r 10 -s 480x800 -i $DISPLAY \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi \
    -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "${HLS_DIR}/lane${i}_%03d.ts" \
    "${HLS_DIR}/lane${i}.m3u8" &

  echo "Started ffmpeg lane${i}"
done

echo "All 4 streams started."
EOF

chmod +x /home/user/vnc-hls/restart-vnc-to-hls.sh
/home/user/vnc-hls/restart-vnc-to-hls.sh
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -r 10 -s 480x800 -i $DISPLAY -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 1M ...
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -r 10 -s 480x800 -i $DISPLAY -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 1M output.mp4
echo $displau
echo $display
echo $DISPLAY
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -r 10 -s 480x800 -i $DISPLAY -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 1M output.mp4
vainfo
echo $DISPLAY
ps aux | grep X
ps aux | grep Xtightvnc
netstat -tlnp | grep 5900
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -r 10 -s 480x800 -i $DISPLAY -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 1M output.mp4
echo $DISPLAY
ps aux | grep X
export DISPLAY=:99
ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -r 10 -s 480x800 -i $DISPLAY -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 1M output.mp4
cat > capture_all.sh << EOF
#!/bin/bash

DEV="/dev/dri/renderD128"
RES="480x800"
FPS=10
BITRATE="1M"

for DISP in 11 12 13 14; do
  DISPLAY=":$DISP"
  OUTPUT="output_display_${DISP}.mp4"
  
  echo "Starting capture on DISPLAY=$DISPLAY -> $OUTPUT"
  
  DISPLAY=$DISPLAY ffmpeg -vaapi_device $DEV -f x11grab -r $FPS -s $RES -i $DISPLAY     -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v $BITRATE $OUTPUT &
done

wait

EOF

chmod +x capture_all.sh
./capture_all.sh
cat > capture_all.sh << 'EOF'
#!/bin/bash

# Device for VAAPI hardware acceleration
DEV="/dev/dri/renderD128"
RES="480x800"
FPS=10
BITRATE="1M"

for DISP in 11 12 13 14; do
  DISPLAY=":$DISP"
  OUTPUT="output_display_${DISP}.mp4"

  echo "Starting capture on DISPLAY=$DISPLAY -> $OUTPUT"

  DISPLAY=$DISPLAY ffmpeg -vaapi_device $DEV -f x11grab -r $FPS -s $RES -i $DISPLAY \
    -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v $BITRATE $OUTPUT &
done

wait
EOF

chmod +x capture_all.sh
./capture_all.sh
cat > capture_all.sh << 'EOF'
#!/bin/bash

DEV="/dev/dri/renderD128"
RES="480x800"
FPS=10
BITRATE="1M"
HLS_TIME=2
HLS_LIST_SIZE=3

for DISP in 11 12 13 14; do
  DISPLAY=":$DISP"
  OUTPUT_DIR="hls_display_${DISP}"
  mkdir -p $OUTPUT_DIR

  echo "Starting capture on DISPLAY=$DISPLAY -> $OUTPUT_DIR/stream.m3u8"

  DISPLAY=$DISPLAY ffmpeg -vaapi_device $DEV -f x11grab -r $FPS -s $RES -i $DISPLAY \
    -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v $BITRATE \
    -f hls -hls_time $HLS_TIME -hls_list_size $HLS_LIST_SIZE -hls_flags delete_segments \
    $OUTPUT_DIR/stream.m3u8 &
done

wait
EOF

chmod +x capture_all.sh
./capture_all.sh
sudo cat > /usr/local/bin/start_all_hls.sh <<'EOF'
#!/bin/bash

# Config: display to stream ID mapping
declare -A DISPLAY_MAP=(
  [":1.0"]="11"
  [":2.0"]="12"
  [":3.0"]="13"
  [":4.0"]="14"
)

RESOLUTION="480x800"
FRAMERATE="10"

for DISPLAY_ID in "${!DISPLAY_MAP[@]}"; do
  STREAM_ID="${DISPLAY_MAP[$DISPLAY_ID]}"
  OUTPUT_DIR="/var/www/html/hls_display_$STREAM_ID"
  OUTPUT_FILE="stream.m3u8"
  LOGFILE="/var/log/vnc_to_hls_$STREAM_ID.log"

  mkdir -p "$OUTPUT_DIR"
  touch "$LOGFILE"
  chmod 666 "$LOGFILE"

  echo "[INFO] Starting X11 HLS stream for display $DISPLAY_ID -> stream $STREAM_ID" | tee -a "$LOGFILE"

  if ls /dev/dri/renderD* &>/dev/null; then
    echo "[INFO] VAAPI found for stream $STREAM_ID, using hardware acceleration." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
      -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
      -init_hw_device vaapi=va:/dev/dri/renderD128 -filter_hw_device va \
      -vf 'format=nv12,hwupload' \
      -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
      -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
      "$OUTPUT_DIR/$OUTPUT_FILE" >> "$LOGFILE" 2>&1 &

  else
    echo "[WARN] No VAAPI found for stream $STREAM_ID, using CPU encoding." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
      -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
      -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M \
      -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
      "$OUTPUT_DIR/$OUTPUT_FILE" >> "$LOGFILE" 2>&1 &
  fi
done

wait
EOF

sudo chmod +x /usr/local/bin/start_all_hls.sh
sudo tee /usr/local/bin/start_all_hls.sh > /dev/null <<'EOF'
#!/bin/bash

# Config: display to stream ID mapping
declare -A DISPLAY_MAP=(
  [":1.0"]="11"
  [":2.0"]="12"
  [":3.0"]="13"
  [":4.0"]="14"
)

RESOLUTION="480x800"
FRAMERATE="10"

for DISPLAY_ID in "${!DISPLAY_MAP[@]}"; do
  STREAM_ID="${DISPLAY_MAP[$DISPLAY_ID]}"
  OUTPUT_DIR="/var/www/html/hls_display_$STREAM_ID"
  OUTPUT_FILE="stream.m3u8"
  LOGFILE="/var/log/vnc_to_hls_$STREAM_ID.log"

  mkdir -p "$OUTPUT_DIR"
  touch "$LOGFILE"
  chmod 666 "$LOGFILE"

  echo "[INFO] Starting X11 HLS stream for display $DISPLAY_ID -> stream $STREAM_ID" | tee -a "$LOGFILE"

  if ls /dev/dri/renderD* &>/dev/null; then
    echo "[INFO] VAAPI found for stream $STREAM_ID, using hardware acceleration." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
      -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
      -init_hw_device vaapi=va:/dev/dri/renderD128 -filter_hw_device va \
      -vf 'format=nv12,hwupload' \
      -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
      -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
      "$OUTPUT_DIR/$OUTPUT_FILE" >> "$LOGFILE" 2>&1 &
  else
    echo "[WARN] No VAAPI found for stream $STREAM_ID, using CPU encoding." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
      -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
      -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M \
      -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
      "$OUTPUT_DIR/$OUTPUT_FILE" >> "$LOGFILE" 2>&1 &
  fi
done

wait
EOF

sudo chmod +x /usr/local/bin/start_all_hls.sh
sudo /usr/local/bin/start_all_hls.sh
ls
cd hls_display_11
ls
sudo ln -s ~/vnc-hls/hls_display_11 /var/www/html/hls_display_11
sudo ln -s ~/vnc-hls/hls_display_12 /var/www/html/hls_display_12
sudo ln -s ~/vnc-hls/hls_display_13 /var/www/html/hls_display_13
sudo ln -s ~/vnc-hls/hls_display_14 /var/www/html/hls_display_14
sudo nano /etc/nginx/sites-enabled/default
sudo tee /etc/nginx/sites-enabled/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;

    location /hls_display_11/ {
        alias /home/user/vnc-hls/hls_display_11/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_12/ {
        alias /home/user/vnc-hls/hls_display_12/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_13/ {
        alias /home/user/vnc-hls/hls_display_13/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_14/ {
        alias /home/user/vnc-hls/hls_display_14/;
        autoindex on;
        add_header Cache-Control no-cache;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Dashboard</title>
<style>
  body {
    margin: 0;
    background: #111;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    gap: 10px;
    font-family: Arial, sans-serif;
  }
  video {
    width: 240px; /* half of 480 to fit 4 videos in row */
    height: 400px; /* half of 800 */
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
    pointer-events: none; /* disable interaction */
  }
</style>
</head>
<body>

<video id="video11" muted autoplay playsinline></video>
<video id="video12" muted autoplay playsinline></video>
<video id="video13" muted autoplay playsinline></video>
<video id="video14" muted autoplay playsinline></video>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);
    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = url;
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

sudo tee /etc/nginx/sites-enabled/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
ls -l /var/www/html/index.html
cd ..
ls
sudo tee /etc/nginx/sites-enabled/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;

    location /hls_display_11/ {
        alias /home/user/vnc-hls/hls_display_11/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_12/ {
        alias /home/user/vnc-hls/hls_display_12/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_13/ {
        alias /home/user/vnc-hls/hls_display_13/;
        autoindex on;
        add_header Cache-Control no-cache;
    }
    location /hls_display_14/ {
        alias /home/user/vnc-hls/hls_display_14/;
        autoindex on;
        add_header Cache-Control no-cache;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

./vnc_to_hls.sh
ls
./vnc_to_hls.sh
nano vnc_to_hls.sh
ls
cd vnc-hls
ls
./vnc_to_hls.sh
sudo ./vnc_to_hls.sh
chmod +x /home/user/vnc_to_hls.sh
./vnc_to_hls.sh
ls -ld /home/user/vnc-hls
ls -ld /home/user
ls -ld /home
ls -l ./vnc_to_hls.sh
head -1 ./vnc_to_hls.sh
cd ..
./vnc_to_hls.sh
sudo ./vnc_to_hls.sh
sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name vnctranscoder;

    root /home/user/vnc-hls/hls;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/vnc-hls /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
ls
cd ..
ls
cd user
ls
cd vnc-hls
ls
sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name vnctranscoder;

    root /home/user/vnc-hls/hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name vnctranscoder;

    root /home/user/vnc-hls;

    location / {
        index index.html;
        autoindex off;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name vnctranscoder;

    root /home/user/vnc-hls;

    location / {
        index index.html;
        autoindex off;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
ls -l /home/user/vnc-hls/index.html
chmod 644 /home/user/vnc-hls/index.html
namei -l /home/user/vnc-hls/index.html
ls -l /etc/nginx/sites-enabled/vnc-hls
sudo mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.bak
sudo nginx -t && sudo systemctl reload nginx
curl -I http://localhost/index.html
sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name vnctranscoder;

    root /home/user/vnc-hls;

    location / {
        index index.html;
        try_files $uri $uri/ =404;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
curl -I http://localhost/index.html
sudo ln -sf /etc/nginx/sites-available/vnc-hls /etc/nginx/sites-enabled/vnc-hls
sudo nginx -t && sudo systemctl reload nginx
ls -l /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
sudo nginx -T | grep 'server_name\|root'
curl -I http://localhost/index.html
sudo nginx -t && sudo systemctl reload nginx
cat <<'EOF' | sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null
server {
    listen 80 default_server;
    server_name _;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

cat <<'EOF' | sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null
server {
    listen 80 default_server;
    server_name _;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
ls -l /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
ls
cat <<'EOF' | sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null
server {
    listen 80 default_server;
    server_name _;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
grep -r "default_server" /etc/nginx
user@vnctranscoder:~/vnc-hls$ sudo nginx -t && sudo systemctl reload nginx
2025/05/21 19:51:31 [emerg] 7592#7592: a duplicate default server for 0.0.0.0:80 in /etc/nginx/sites-enabled/vnc-hls:2
nginx: configuration file /etc/nginx/nginx.conf test failed
user@vnctranscoder:~/vnc-hls$ 
sudo rm /etc/nginx/sites-enabled/default.bak
cat <<'EOF' | sudo tee /etc/nginx/sites-available/vnc-hls > /dev/null
server {
    listen 80 default_server;
    server_name _;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        try_files $uri $uri/ =404;
    }

    location ~ \.m3u8$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }

    location ~ \.ts$ {
        add_header Cache-Control no-cache;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/vnc-hls /etc/nginx/sites-enabled/vnc-hls
sudo nginx -t && sudo systemctl reload nginx
curl -I http://localhost/index.html
ps -eo pid,ppid,user,stat,etime,cmd --sort=etime
sudo tee vnc-to-hls.sh > /dev/null << 'EOF'
#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"

for i in ${!IPS[@]}; do
  IP=${IPS[$i]}
  DISPLAY=${DISPLAYS[$i]}
  
  HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1)).m3u8"
  HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}$((i+1))_%d.ts"

  echo "[INFO] Starting stream from $IP on display $DISPLAY"

  ffmpeg -hide_banner -loglevel info \
    -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i $DISPLAY \
    -vaapi_device "$VAAPI_DEVICE" \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
    -hls_time 4 -hls_list_size 6 -hls_flags delete_segments+append_list \
    -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
    "$HLS_PLAYLIST" &
done

wait
EOF

nc -zv 192.168.4.104 5900
sudo netstat -tulpn | grep 5900  # on .104
ping 192.168.4.104
ip route  # on transcoder
user@vnctranscoder:~/vnc-hls$ nc -zv 192.168.4.104 5900
sudo netstat -tulpn | grep 5900  # on .104
ping 192.168.4.104
ip route  # on transcoder
Connection to 192.168.4.104 5900 port [tcp/*] succeeded!
[sudo] password for user: 
PING 192.168.4.104 (192.168.4.104) 56(84) bytes of data.
64 bytes from 192.168.4.104: icmp_seq=1 ttl=64 time=0.217 ms
64 bytes from 192.168.4.104: icmp_seq=2 ttl=64 time=0.433 ms
64 bytes from 192.168.4.104: icmp_seq=3 ttl=64 time=0.264 ms
64 bytes from 192.168.4.104: icmp_seq=4 ttl=64 time=0.243 ms
64 bytes from 192.168.4.104: icmp_seq=5 ttl=64 time=0.226 ms
64 bytes from 192.168.4.104: icmp_seq=6 ttl=64 time=0.264 ms
--- 192.168.4.104 ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5138ms
rtt min/avg/max/mdev = 0.217/0.274/0.433/0.073 ms
default via 192.168.1.1 dev enp1s0 proto dhcp src 192.168.253.37 metric 100 
192.168.0.0/16 dev enp1s0 proto kernel scope link src 192.168.253.37 metric 100 
192.168.1.1 dev enp1s0 proto dhcp scope link src 192.168.253.37 metric 100 
user@vnctranscoder:~/vnc-hls$ 
curl telnet://192.168.4.104:5900
telnet 192.168.4.104 5900
sudo ip neigh flush all
ffmpeg -v debug -f vnc -i "vnc://192.168.4.104:5900?password=wuotu1Iocheegi6u" -f null -
ls
ip a
ip route
ping 192.168.4.104
nc -zv 192.168.4.104 5900
ls
cd ..
ls
ip a
ip route
ping 192.168.4.104
nc -zv 192.168.4.104 5900
ls
nano vnc_to_hls.sh
./vnc_to_hls
./vnc_to_hls.sh
ls
cd vnc-hls
nano vnc_to_hls.sh
cd ..
nano vnc_to_hls.sh
sudo grep -r 'listen' /etc/nginx/
sudo tail -n 100 /var/log/nginx/error.log
arp -a | grep 192.168.4.104
docker exec -it <container> bash
ip route
ping 192.168.4.104
docker exec -it vnc-to-hls.sh bash
sudo snap install docker
docker exec -it vnc-to-hls.sh bash
sudo docker exec -it vnc-to-hls.sh bash
docker exec -it vnc-to-hls.sh bash
sudo docker exec -it vnc-to-hls.sh bash
cd vnc-hls
sudo docker exec -it vnc-to-hls.sh bash
docker ps
sudo docker ps
server {
}
sudo tail -f /var/log/nginx/dashboard_access.log /var/log/nginx/dashboard_error.log
sudo tcpdump -i eth0 host 192.168.4.104 and port 8080
iplink
ip link
sudo tcpdump -i enp1s0 host 192.168.4.104 and port 8080
sudo tcpdump -i <your_interface> host 192.168.4.104 and port 5900
sudo tcpdump -i enp1s0 host 192.168.4.104 and port 5900
mkdir -p dev-scripts
if [ -s vnc-to-hls.sh ]; then   find . -maxdepth 1 -type f -name '*.sh' ! -name 'vnc-to-hls.sh' -exec mv {} dev-scripts/ \;; else   echo "Warning: vnc-to-hls.sh does not exist or is empty; skipping move"; fi
ls
cd ..
ls
nano vnc-2-hls.sh
nano vnc-to-hls.sh
nano vnc_2_hls.sh
nano vnc_to_hls.sh
./vnc_2_hls.sh
sudo apt update
sudo apt install -y ffmpeg tigervnc-standalone-server tigervnc-viewer xvfb
sudo mkdir -p /var/www/html/vnc1
sudo chown $USER:$USER /var/www/html/vnc1
sudo mkdir -p /var/www/html/vnc1
sudo chown $USER:$USER /var/www/html/vnc1
# Start a virtual X display on :99
Xvfb :99 -screen 0 480x800x24 &
# Export DISPLAY so apps know where to render
export DISPLAY=:99
# Start VNC viewer connected to the source stream
vncviewer -passwd <(echo wuotu1Iocheegi6u) 192.168.4.101 &
sudo tee /var/www/html/dashboard.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Dashboard</title>
<style>
  body {
    margin: 0;
    background: #111;
    color: #eee;
    font-family: Arial, sans-serif;
  }
  .container {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    align-items: center;
    height: 100vh;
    gap: 10px;
    padding: 10px;
  }
  video {
    width: 23%; /* Four videos in one row with some gap */
    height: auto;
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
  }
</style>
</head>
<body>

<div class="container">
  <video id="video11" controls muted autoplay></video>
  <video id="video12" controls muted autoplay></video>
  <video id="video13" controls muted autoplay></video>
  <video id="video14" controls muted autoplay></video>
</div>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);

    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = url;
      video.addEventListener('error', e => {
        console.error(`Native HLS error on ${id}`, e);
      });
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
      hls.on(Hls.Events.ERROR, function(event, data) {
        console.error(`hls.js error on ${id}`, data);
      });
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

./vnc_2_hls.sh
sudo tee /var/www/html/dashboard.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Dashboard</title>
<style>
  body {
    margin: 0;
    background: #111;
    color: #eee;
    font-family: Arial, sans-serif;
  }
  .container {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    align-items: center;
    height: 100vh;
    gap: 10px;
    padding: 10px;
  }
  video {
    width: 23%; /* Four videos in one row with some gap */
    height: auto;
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
  }
</style>
</head>
<body>

<div class="container">
  <video id="video11" controls muted autoplay></video>
  <video id="video12" controls muted autoplay></video>
  <video id="video13" controls muted autoplay></video>
  <video id="video14" controls muted autoplay></video>
</div>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);

    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = url;
      video.addEventListener('error', e => {
        console.error(`Native HLS error on ${id}`, e);
      });
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
      hls.on(Hls.Events.ERROR, function(event, data) {
        console.error(`hls.js error on ${id}`, data);
      });
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

sudo nginx -t && sudo systemctl reload nginx
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Dashboard</title>
<style>
  body {
    margin: 0;
    background: #111;
    color: #eee;
    font-family: Arial, sans-serif;
  }
  .container {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    align-items: center;
    height: 100vh;
    gap: 10px;
    padding: 10px;
  }
  video {
    width: 23%; /* Four videos in one row with some gap */
    height: auto;
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
  }
</style>
</head>
<body>

<div class="container">
  <video id="video11" controls muted autoplay></video>
  <video id="video12" controls muted autoplay></video>
  <video id="video13" controls muted autoplay></video>
  <video id="video14" controls muted autoplay></video>
</div>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);

    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = url;
      video.addEventListener('error', e => {
        console.error(`Native HLS error on ${id}`, e);
      });
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
      hls.on(Hls.Events.ERROR, function(event, data) {
        console.error(`hls.js error on ${id}`, data);
      });
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

sudo cat /var/www/html/index.html
sudo systemctl restart nginx
sudo grep -r "root" /etc/nginx/sites-enabled/
sudo nano /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>VNC HLS Dashboard</title>
<style>
  body {
    margin: 0;
    background: #111;
    color: #eee;
    font-family: Arial, sans-serif;
  }
  .container {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    align-items: center;
    height: 100vh;
    gap: 10px;
    padding: 10px;
  }
  video {
    height: 90vh;          /* tall for portrait */
    aspect-ratio: 3 / 5;   /* 480x800 ratio */
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
  }
</style>
</head>
<body>

<div class="container">
  <video id="video11" controls muted autoplay></video>
  <video id="video12" controls muted autoplay></video>
  <video id="video13" controls muted autoplay></video>
  <video id="video14" controls muted autoplay></video>
</div>

<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<script>
  const streams = {
    video11: "/hls_display_11/stream.m3u8",
    video12: "/hls_display_12/stream.m3u8",
    video13: "/hls_display_13/stream.m3u8",
    video14: "/hls_display_14/stream.m3u8",
  };

  Object.entries(streams).forEach(([id, url]) => {
    const video = document.getElementById(id);

    if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Native HLS support (Safari, iOS)
      video.src = url;
      video.addEventListener('error', e => {
        console.error(`Native HLS error on ${id}`, e);
      });
    } else if (Hls.isSupported()) {
      // hls.js fallback for other browsers
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
      hls.on(Hls.Events.ERROR, function(event, data) {
        console.error(`hls.js error on ${id}`, data);
      });
    } else {
      console.error("HLS not supported in this browser");
    }
  });
</script>

</body>
</html>
EOF

sudo tail -f /var/log/nginx/error.log
ls
cd hls_output
ls
cd ..
cd hls
ls
nano vnc-to-hls.sh
nano vnc_to_hls.sh
sudo nano vnc_to_hls.sh
./vnc_to_hls.sh
cd ..
./vnc_to_hls.sh
sudo nano vnc_to_hls.sh
sudo cat > /home/user/vnc_to_hls.sh <<'EOF'
#!/bin/bash

# Usage: ./vnc_to_hls.sh <VNC_IP> <DISPLAY_ID>
# Example: ./vnc_to_hls.sh 192.168.4.101 11

VNC_IP="\$1"
DISPLAY_ID="\$2"

FRAMERATE="5"
RESOLUTION="480x800"
OUTPUT_DIR="/var/www/html/hls_display_\$DISPLAY_ID"
OUTPUT_FILE="stream.m3u8"
LOGFILE="/var/log/vnc_to_hls_\$DISPLAY_ID.log"

mkdir -p "\$OUTPUT_DIR"
touch "\$LOGFILE"

if ls /dev/dri/renderD* >/dev/null 2>&1; then
    echo "[INFO] VAAPI device found. Using hardware acceleration." | tee -a "\$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f vnc -i "\$VNC_IP:0" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -r \$FRAMERATE -s \$RESOLUTION \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "\$OUTPUT_DIR/\$OUTPUT_FILE" 2>&1 | tee -a "\$LOGFILE"
else
    echo "[WARN] VAAPI device not found. Falling back to CPU encoding." | tee -a "\$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f vnc -i "\$VNC_IP:0" \
        -r \$FRAMERATE -s \$RESOLUTION \
        -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M \
        -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "\$OUTPUT_DIR/\$OUTPUT_FILE" 2>&1 | tee -a "\$LOGFILE"
fi
EOF

sudo chmod +x /home/user/vnc_to_hls.sh
./vnc_to_hls.sh
sudo cat > ~/vnc_to_hls.sh <<'EOF'
#!/bin/bash

# Configuration
DISPLAY_ID="$1"         # Example: :1.0
OUTPUT_DIR="/var/www/html/hls_display_$2"
OUTPUT_FILE="stream.m3u8"
RESOLUTION="480x800"
FRAMERATE="10"
LOGFILE="/var/log/vnc_to_hls_$2.log"

mkdir -p "$OUTPUT_DIR"

echo "[INFO] Starting X11 HLS stream for display $DISPLAY_ID" | tee -a "$LOGFILE"

# Check for VAAPI support
if ls /dev/dri/renderD* &>/dev/null; then
    echo "[INFO] VAAPI device found. Using hardware acceleration." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -vf 'format=nv12,hwupload' \
        -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -keyint_min 30 \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
else
    echo "[WARN] VAAPI device not found. Falling back to CPU encoding." | tee -a "$LOGFILE"

    ffmpeg -hide_banner -loglevel info \
        -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY_ID" \
        -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1M -maxrate 1M -bufsize 2M \
        -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments \
        "$OUTPUT_DIR/$OUTPUT_FILE" 2>&1 | tee -a "$LOGFILE"
fi
EOF

sudo chmod +x ~/vnc_to_hls.sh
./vnc_to_hls.sh
ls
nano log1.log
curl -I http://192.168.253.37/hls_display_11/stream.m3u8
ls
cd hls_output
ls
cd ..
cd hls
ls
cd ..
cd vnc-hls
ls
cd hls_display_11
ls
sudo -u www-data ls -l /home/user/vnc-hls/hls_display_11/stream.m3u8
sudo -u www-data ls -ld /home/user/vnc-hls/hls_display_11/
sudo chmod -R o+r /home/user/vnc-hls/hls_display_11/
sudo chmod o+x /home/user/vnc-hls/hls_display_11
sudo chmod -R o+r /home/user/vnc-hls/hls_display_11/
sudo -u www-data ls -ld /home/user/vnc-hls/hls_display_11/
sudo -u www-data ls -l /home/user/vnc-hls/hls_display_11/stream.m3u8
sudo systemctl reload nginx
sudo nginx -T | grep hls
cdls
ls
cd ..
s
ls
cd ..
ls
cd ..
ls
cd etc
ls
cd nginx
cd sites-enabled
ls
cd vns-hls
cd vnc-hls
ls
cd vnc_hs
cd vnc_hls
nano vnc_hls
arp -a | grep 192.168.4.104
sudo apt install net-tools
sudo ufw status
sudo netstat -tulpn | grep 8080
