    a.button {
      margin-top: 8px;
      padding: 6px 12px;
      background: #337ab7;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-size: 14px;
    }
    a.button:hover {
      background: #286090;
    }
  </style>
</head>
<body>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_11/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_12/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_13/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_14/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

</body>
</html>
EOF

ls
cd ...
cd ..
ls
cd var
cd www
cd html
ls
cd novnc
ls
cd noVNC
ls
cd ~/vnc-hls
ls
cd ..
cp -r /var/www/html/novnc ~/vnc-hls/
# Create target directory if needed
mkdir -p ~/vnc-hls
# Copy noVNC from /var/www/html to ~/vnc-hls
cp -r /var/www/html/novnc ~/vnc-hls/
ls -l /var/www/html
ls
cd vnc-hls
ls
mkdir -p ~/vnc-hls
cd ~/vnc-hls
git clone https://github.com/novnc/noVNC.git novnc
cd ~/vnc-hls/novnc
./utils/novnc_proxy --vnc localhost:5900 --listen 6081
sudo apt-get install tmux
tmux new -s transcoder
top
tee ~/vnc-hls/new.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>VNC HLS Dashboard</title>
  <style>
    body {
      margin: 0;
      background: #111;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      height: 100vh;
      font-family: Arial, sans-serif;
      gap: 20px;
    }
    .video-container {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    video {
      width: 240px;
      height: 400px;
      background: black;
      border: 2px solid #444;
      border-radius: 6px;
      pointer-events: none;
    }
    a.button {
      margin-top: 8px;
      padding: 6px 12px;
      background: #337ab7;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-size: 14px;
    }
    a.button:hover {
      background: #286090;
    }
  </style>
</head>
<body>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_11/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.4.101:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.101&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_12/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.4.102:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.102&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_13/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.4.103:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.103&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_14/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.4.104:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.104&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

</body>
</html>
EOF

tee ~/vnc-hls/new.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>VNC HLS Dashboard</title>
  <style>
    body {
      margin: 0;
      background: #111;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      height: 100vh;
      font-family: Arial, sans-serif;
      gap: 20px;
    }
    .video-container {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    video {
      width: 240px;
      height: 400px;
      background: black;
      border: 2px solid #444;
      border-radius: 6px;
      pointer-events: none;
    }
    a.button {
      margin-top: 8px;
      padding: 6px 12px;
      background: #337ab7;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-size: 14px;
    }
    a.button:hover {
      background: #286090;
    }
  </style>
</head>
<body>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_11/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.101&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_12/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.102&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_13/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.103&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_14/stream.m3u8"></video>
  <a class="button"
     href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.104&port=5900&password=wuotu1Iocheegi6u"
     target="_blank">
    Interact
  </a>
</div>

</body>
</html>
EOF

git push
cat << 'EOF' > ~/start-novnc.sh
#!/bin/bash

export DISPLAY=:1

# Start virtual framebuffer with 480x800 resolution
Xvfb :1 -screen 0 480x800x24 &

# Give Xvfb a second to initialize
sleep 1

# Start VNC server
x11vnc -display :1 -forever -nopw -shared &

# Start noVNC (adjust path if necessary)
websockify --web /usr/share/novnc/ 6080 localhost:5900 &
EOF

chmod +x ~/start-novnc.sh
~/start-novnc.sh
git clone https://github.com/novnc/noVNC.git ~/noVNC
cat << 'EOF' > ~/start-novnc.sh
#!/bin/bash

export DISPLAY=:1

# Start virtual framebuffer with 480x800 resolution
Xvfb :1 -screen 0 480x800x24 &

# Give Xvfb a second to initialize
sleep 1

# Start VNC server
x11vnc -display :1 -forever -nopw -shared -noxdamage &

# Start noVNC (serves from the ~/noVNC folder)
websockify --web ~/noVNC 6080 localhost:5900 &
EOF

~/start-novnc.sh
ps aux | grep websockify
sudo lsof -iTCP:6081 -sTCP:LISTEN
websockify --web /home/user/noVNC 6081 192.168.4.101:5900
websockify 6081 192.168.4.101:5900 --web /home/user/noVNC
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>T-Bar Gates Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
<style>
</style>
</head>
<body>
<script>
</script>
</body>
</html>
ls
cd vnc-hls
ls
cat > v3.html << EOF
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
  .feed a.button {
    margin-top: 0.5rem;
    text-align: center;
    display: inline-block;
    background: #3366cc;
    color: white;
    text-decoration: none;
    padding: 0.3rem 0.7rem;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
  }
  .feed a.button:hover {
    background: #224499;
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
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.101&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc101', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.101
      </a>
    </div>
    <div class="feed">
      <video id="video2" controls autoplay muted></video>
      <label>192.168.4.102 (Lane 2)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.102&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc102', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.102
      </a>
    </div>
    <div class="feed">
      <video id="video3" controls autoplay muted></video>
      <label>192.168.4.103 (Lane 3)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.103&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc103', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.103
      </a>
    </div>
    <div class="feed">
      <video id="video4" controls autoplay muted></video>
      <label>192.168.4.104 (Lane 4)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.104&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc104', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.104
      </a>
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

ls
cat > v4.html << EOF
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
  .feed a.button {
    margin-top: 0.5rem;
    text-align: center;
    display: inline-block;
    background: #3366cc;
    color: white;
    text-decoration: none;
    padding: 0.3rem 0.7rem;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
  }
  .feed a.button:hover {
    background: #224499;
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
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.101&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc101', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.101
      </a>
    </div>
    <div class="feed">
      <video id="video2" controls autoplay muted></video>
      <label>192.168.4.102 (Lane 2)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.102&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc102', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.102
      </a>
    </div>
    <div class="feed">
      <video id="video3" controls autoplay muted></video>
      <label>192.168.4.103 (Lane 3)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.103&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc103', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.103
      </a>
    </div>
    <div class="feed">
      <video id="video4" controls autoplay muted></video>
      <label>192.168.4.104 (Lane 4)</label>
      <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.4.104&port=5900&password=wuotu1Iocheegi6u"
         onclick="window.open(this.href, 'vnc104', 'width=480,height=800,resizable=yes'); return false;">
         Open VNC for 192.168.4.104
      </a>
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

cd ..
ls
cd ..
ls
cd ..
ls
rm index.html
ls -l /home/user/vnc-hls/hls/
cat /home/user/vnc-hls/hls/lane1.m3u8
cat <<'EOF'
# Add this inside your nginx `server` block:
location ~ \.(m3u8|ts)$ {
    add_header Cache-Control no-cache;
    add_header Pragma no-cache;
    add_header Expires 0;
}
EOF

sudo nginx -s reload
cat <<'EOF'
# In your ffmpeg command, change -hls_list_size to 12 or more:
-hls_list_size 12
EOF

watch -n 1 cat /home/user/vnc-hls/hls/lane1.m3u8
cat <<'EOF'
# In your ffmpeg command, change -hls_list_size to 12 or more:
-hls_list_size 12
EOF

sed -i 's/-hls_list_size [0-9]\+/-hls_list_size 12/g' ~/vnc-to-hls.sh
sudo nginx -s reload
ls
cd vnc-hls
ls
cd hs
cd hls
ls
cd ..
ls
cd ..
ls
cd vnc-hls
ls
cd nginx-dashboard
cd nginx-dashaord
cd nginx-dashboard
cd nginx_dashbaord
cd nginx_dashboard
ls
ps aux | grep nginx
nginx -T 2>/dev/null | head -n 20
nginx -V 2>&1 | grep -- '--conf-path'
ps aux | grep nginx
cdls
cd
cd ..
ls
cd ..
ls
cd usr/sbin
cd nginx
ls
cd nginx
ps aux | grep nginx
nginx -T 2>/dev/null | head -n 20
nginx -V 2>&1 | grep -- '--conf-path'
grep include /etc/nginx/nginx.conf
ls /etc/nginx/sites-enabled/
sudo tee -a /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'

# HLS: disable caching and enable CORS for .m3u8 and .ts files
location ~ \.(m3u8|ts)$ {
    add_header Cache-Control "no-cache";
    add_header Pragma "no-cache";
    add_header Expires 0;
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Headers *;
    add_header Access-Control-Expose-Headers *;
    types {
        application/vnd.apple.mpegurl m3u8;
        video/mp2t ts;
    }
}
EOF

sudo nginx -s reload
cd /home/user/vnc-hls/hls
python3 -m http.server 8080
cat > /home/user/vnc-hls/hls/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>HLS Stream Test</title>
</head>
<body>
  <h2>Lane 1</h2>
  <video id="video1" width="480" height="320" controls></video>
  <h2>Lane 2</h2>
  <video id="video2" width="480" height="320" controls></video>
  <h2>Lane 3</h2>
  <video id="video3" width="480" height="320" controls></video>
  <h2>Lane 4</h2>
  <video id="video4" width="480" height="320" controls></video>
  <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
  <script>
    function loadStream(videoId, m3u8) {
      var video = document.getElementById(videoId);
      if (Hls.isSupported()) {
        var hls = new Hls();
        hls.loadSource(m3u8);
        hls.attachMedia(video);
      } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        video.src = m3u8;
      }
    }
    loadStream('video1', 'lane1.m3u8');
    loadStream('video2', 'lane2.m3u8');
    loadStream('video3', 'lane3.m3u8');
    loadStream('video4', 'lane4.m3u8');
  </script>
</body>
</html>
EOF

cat /home/user/vnc-hls/hls/lane2.m3u8
ls -l /home/user/vnc-hls/hls/lane2*
# Also:
ls -l /home/user/vnc-hls/hls/
cat lane1.m3u8
cat lane2.m3u8
cat lane3.m3u8
cat lane4.m3u8
cat lane1.m3u8
cat lane2.m3u8
sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log
cd ..
ls
cd ..
ls
cd etc
cd nginx
ls
cd sites-enabled/vnc-hls
cd sites-enabled
ls
cd vnc-hls
ls
cat /etc/nginx/sites-enabled/vnc-hls
cat > /etc/nginx/sites-enabled/vnc-hls <<'EOF'
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

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
cat /etc/nginx/sites-enabled/vnc-hls
sdf
cat /etc/nginx/sites-enabled/vnc-hls
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
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

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
cat /home/user/vnc-hls/hls/lane1.m3u8
cd home
cdcd home
cd ..
s
ls
cd ..
cd ome
cd home
cd usr
cd user
cd vnc-hls
ls
cat /home/user/vnc-hls/hls/lane1.m3u8
ls -lhtr /home/user/vnc-hls/hls/
ps aux | grep ffmpeg
df -h
cd ..
nano vnc-to-hls.sj
nano vnc-to-hls.sh
cat vnc-to-hls.sh
pkill ffmpeg
pkill vncviewer
pkill Xvfb
rm -f /home/user/vnc-hls/hls/lane*.ts /home/user/vnc-hls/hls/lane*.m3u8
./vnc-to-hls.sh
ls
./vnc-to-hls.sh
echo "127.0.0.1 dashboard" | sudo tee -a /etc/hosts
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        try_files \$uri \$uri/ =404;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
ping 192.168.1.10
ping 192.168.1.11
ip a
sudo cp /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.bak 2>/dev/null
sudo tee /etc/netplan/01-netcfg.yaml > /dev/null <<'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
      addresses: [192.168.1.11/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
EOF

sudo netplan apply
ip a
ls -l /home/user/vnc-hls/
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard 192.168.1.11;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files \$uri \$uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
sudo nginx -t
ls -ld /home/user/vnc-hls
ls -ld /home/user /home/user/vnc-hls
ls -l /home/user/vnc-hls/index.html
sudo tail -n 20 /var/log/nginx/error.log
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard 192.168.1.11;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files $uri $uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
echo "127.0.0.1 dashboard.internal" | sudo tee -a /etc/hosts
echo "192.168.1.11 dashboard.internal" | sudo tee -a /etc/hosts
sudo tee /etc/nginx/sites-enabled/vnc-hls > /dev/null <<'EOF'
server {
    listen 80;
    server_name dashboard.internal;

    root /home/user/vnc-hls;

    location / {
        autoindex on;
        try_files $uri $uri/ /index.html;
    }

    location /hls/ {
        alias /home/user/vnc-hls/hls/;
        add_header Cache-Control "no-cache";
        add_header Pragma "no-cache";
        add_header Expires 0;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Headers *;
        add_header Access-Control-Expose-Headers *;
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
    }
}
EOF

sudo nginx -s reload
ls
cd vnc-hls
git status
git remote -v
git log --oneline -n 5
git diff ../vnc-to-hls.sh
git diff --name-status
git add -A
git commit -m "WIP: local changes and deletions from live run"
git push origin main
LS
ls
rm *.html
ls
cd vnc-hls
s
git restore index.html
ls
cd ..
ls
pw
pwd
ls
sudo nano /etc/systemd/system/vnc-to-hls.service
cat << 'EOF' | sudo tee /etc/systemd/system/vnc-to-hls.service > /dev/null
[Unit]
Description=VNC to HLS Transcoder
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=user
ExecStart=/home/user/vnc-to-hls.sh
Restart=always
RestartSec=5
Environment=DISPLAY=:0
Environment=XDG_RUNTIME_DIR=/run/user/1000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vnc-to-hls.service
sudo systemctl start vnc-to-hls.service
systemctl status vnc-to-hls.service
sudo reboot
systemctl status vnc-to-hls.service
sudo reboot
ls
vnc
sudo journalctl -u vnc-to-hls.service -f
ls
ffplay /home/user/vnc-hls/hls/lane1.m3u8
vncviewer 192.168.4.101:5900 -passwd /home/user/.vnc/passwd
vncviewer 192.168.4.101:5900
vncviewer 192.168.4.102:5900
ps aux | grep Xvfb
ls -l /home/user/.vnc/passwd
cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Start vncviewer and log output
vncviewer -ViewOnly=1 -Fullscreen=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > /tmp/vncviewer_lane1.log 2>&1 &

VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

kill $VNC_PID
kill $XVFB_PID
echo "[INFO] Log output from vncviewer:"
cat /tmp/vncviewer_lane1.log

EOF

./lane1-test.sh
#!/bin/bash
export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2
xauth generate :11 . trusted
# Start vncviewer and log output
vncviewer -ViewOnly=1 -Fullscreen=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > /tmp/vncviewer_lane1.log 2>&1 &
VNC_PID=$!
echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30
kill $VNC_PID
kill $XVFB_PID
echo "[INFO] Log output from vncviewer:"
cat /tmp/vncviewer_lane1.log
chmod +x lane1-test.sh
./lane1-test.sh
user@vnctranscoder:~$ chmod +x lane1-test.sh
./lane1-test.sh
(EE) 
Fatal server error:
(EE) Server is already active for display 11
	If this server is no longer running, remove /tmp/.X11-lock
	and start again.
(EE) 
xauth:  file  does not exist
xauth:  unable to rename authority file , use -n
[INFO] Xvfb PID: 
[INFO] vncviewer PID: 
[INFO] Waiting 30s to capture connection...
user@vnctranscoder:~$ chmod +x lane1-test.sh
./lane1-test.sh
(EE) 
Fatal server error:
(EE) Server is already active for display 11
	If this server is no longer running, remove /tmp/.X11-lock
	and start again.
(EE) 
xauth:  file  does not exist
xauth:  unable to rename authority file , use -n
[INFO] Xvfb PID: 
[INFO] vncviewer PID: 
[INFO] Waiting 30s to capture connection...
[200~pkill -f "Xvfb :11"
pkill -f "Xvfb :11"
pkill -f "vncviewer .*192.168.4.101"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Log output path
LOG_FILE="/tmp/vncviewer_lane1.log"

# Start vncviewer with logging
vncviewer -ViewOnly=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > "$LOG_FILE" 2>&1 &
VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

# Cleanup
kill $VNC_PID
kill $XVFB_PID
rm -f "$XAUTH_FILE"

echo "[INFO] Log output from vncviewer:"
cat "$LOG_FILE"

EOF

cat > lane1-test.sh << EOF
#!/bin/bash

export DISPLAY=":11"
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"

# Start virtual framebuffer
Xvfb :11 -screen 0 480x800x24 &
XVFB_PID=$!
sleep 2

xauth generate :11 . trusted

# Log output path
LOG_FILE="/tmp/vncviewer_lane1.log"

# Start vncviewer with logging
vncviewer -ViewOnly=1 -Shared 192.168.4.101:5900 -passwd /home/user/.vnc/passwd > "$LOG_FILE" 2>&1 &
VNC_PID=$!

echo "[INFO] Xvfb PID: $XVFB_PID"
echo "[INFO] vncviewer PID: $VNC_PID"
echo "[INFO] Waiting 30s to capture connection..."
sleep 30

# Cleanup
kill $VNC_PID
kill $XVFB_PID
rm -f "$XAUTH_FILE"

echo "[INFO] Log output from vncviewer:"
cat "$LOG_FILE"

EOF

chmod +x lane1-test.sh
./lane1-test.sh
ls
cd tmp
ls
cd ..
ls
cd tmp
ls
nano vncviewer_lane1.log
# Clean everything first
pkill -f "Xvfb :11"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
# Start clean Xvfb
Xvfb :11 -screen 0 480x800x24 &
export DISPLAY=":11"
sleep 2
# Generate xauth
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate :11 . trusted
# Try to run a tiny X11 app (headless-safe)
xclock &
sleep 5
pkill xclock
reboot
sudo reboot
ls
pkill -f "Xvfb :11"
pkill -f "vncviewer .*192.168.4.101"
rm -f /tmp/.X11-unix/X11
rm -f /tmp/.X11-lock
./lane1-test.sh
ps aux | grep Xvfb
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd > "/tmp/vncviewer_${IP}.log" 2>&1 &
ls
cd vnc-hls
ls
cd hls
ls
cd ..
ls
cat > new.sh << EOF
[200~#!/bin/bash

set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    echo "[`date`] [INFO] Starting Xvfb on $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date`] [INFO] Xvfb PID: $XVFB_PID"
    sleep 2

    echo "[`date`] [INFO] Generating xauth for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted

    export DISPLAY="$DISPLAY_NUM"

    echo "[`date`] [INFO] Starting vncviewer to connect to $IP"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date`] [INFO] vncviewer PID: $VNC_PID"

    sleep 5

    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date`] [INFO] Starting ffmpeg to capture $DISPLAY_NUM to HLS"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY_NUM"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST"

  } >> "$LOG_FILE" 2>&1 &
done

wait
~
EOF

nano new.sh
systemctl | grep vnc
sudo systemctl stop vnc-to-hls.service
pgrep -af "vncviewer|Xvfb|ffmpeg"
pkill -f "vncviewer"
pkill -f "Xvfb"
pkill -f "ffmpeg"
./new.sh
chmod +x /home/user/vnc-hls/new.sh
chmod +x new.sh
./new.sh
dos2unix /home/user/vnc-hls/new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
ls
mkdir logs
cd vnc-hls
ls
mkdir logs
./new.sh
cd ..
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
nano new.sh
./new.sh
IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
for i in "${!IPS[@]}"; do echo "$i - ${IPS[$i]}"; done
cat > test.sh << EOF
#!/bin/bash
set -euo pipefail

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

echo "IPS array: ${IPS[*]}"
echo "DISPLAYS array: ${DISPLAYS[*]}"

for i in "${!IPS[@]}"; do
  echo "Index: $i, IP: ${IPS[$i]}, Display: ${DISPLAYS[$i]}"
done

EOF

./test.sh
chmod -x test.sh
./test.sh
chmod +x test.sh
./test.sh
DISPLAYS=(":11" ":12" ":13" ":14")
echo "${DISPLAYS[@]}"
cat > t2.sh << EOF 
#!/bin/bash
set -euo pipefail

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

echo "IPS array: ${IPS[*]}"
echo "DISPLAYS array: ${DISPLAYS[*]}"

for i in "${!IPS[@]}"; do
  echo "Index: $i, IP: ${IPS[$i]}, Display: ${DISPLAYS[$i]}"
done

EOF

chmod +x t2.sh
./t2/sh
./t2.sh
systemctl | grep vnc
cat > new.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    # Create temporary Xauthority file for this display
    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    # Start Xvfb
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

    sleep 2

    # Generate xauth entry
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

    export DISPLAY="$DISPLAY_NUM"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

    # Start vncviewer in view-only fullscreen mode
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

    sleep 5

    # Prepare ffmpeg streaming
    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

    # Optionally wait here or background all and let systemd manage lifecycle
  } >> "$LOG_FILE" 2>&1 &
done

wait

EOF

chmod +x new.sh
./new.sh
nano new.sh
rm new.sh
ls
cat > new.sh << EOF
mkdir -p "$LOG_DIR"
cat > new.sh << EOF
mkdir -p "$LOG_DIR"
EOF
rm new.sh
cat > new.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

    # Create temporary Xauthority file for this display
    XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
    export XAUTHORITY="$XAUTH_FILE"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generated XAUTHORITY file at $XAUTH_FILE"

    # Start Xvfb
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting Xvfb on display $DISPLAY_NUM"
    Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
    XVFB_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Xvfb started with PID $XVFB_PID"

    sleep 2

    # Generate xauth entry
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Generating xauth entry for $DISPLAY_NUM"
    xauth generate "$DISPLAY_NUM" . trusted
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] xauth entry generated"

    export DISPLAY="$DISPLAY_NUM"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] DISPLAY set to $DISPLAY"

    # Start vncviewer in view-only fullscreen mode
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting vncviewer on $IP (lane $LANE_NUM)"
    vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
    VNC_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] vncviewer started with PID $VNC_PID"

    sleep 5

    # Prepare ffmpeg streaming
    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info       -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"       -vaapi_device "$VAAPI_DEVICE"       -vf 'format=nv12,hwupload'       -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0       -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list       -hls_segment_filename "$HLS_SEGMENT_PATTERN"       "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

    # Optionally wait here or background all and let systemd manage lifecycle
  } >> "$LOG_FILE" 2>&1 &
done

wait

EOF

./new.sh
chmod +x new.sh
./new.sh
nano new.sh
rm new.sh
ls
nano new.sh
ls
cat > ~/new.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

for i in "${!IPS[@]}"; do
  IP=${IPS[$i]}
  DISPLAY_NUM=${DISPLAYS[$i]}
  LANE_NUM=$((i + 1))
  LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting setup for lane $LANE_NUM (IP $IP, DISPLAY $DISPLAY_NUM)"

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

    HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
    HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
    ffmpeg -hide_banner -loglevel info \
      -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY" \
      -vaapi_device "$VAAPI_DEVICE" \
      -vf 'format=nv12,hwupload' \
      -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0 \
      -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list \
      -hls_segment_filename "$HLS_SEGMENT_PATTERN" \
      "$HLS_PLAYLIST" &
    FFMPEG_PID=$!
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] ffmpeg started with PID $FFMPEG_PID"

  } >> "$LOG_FILE" 2>&1 &
done

wait
EOF

ls
nano new.sh
chmod +x new.sh
./new.sh
cat /home/user/vnc-hls/logs/lane4.log
user@vnctranscoder:~$ cat /home/user/vnc-hls/logs/lane4.log
[2025-05-26 18:28:46] [INFO] Starting setup for lane 4 (IP 192.168.4.104, DISPLAY :14)
[2025-05-26 18:28:46] [INFO] Generated XAUTHORITY file at /tmp/.Xauthority.E5sg5j
[2025-05-26 18:28:46] [INFO] Starting Xvfb on display :14
[2025-05-26 18:28:46] [INFO] Xvfb started with PID 1842
The XKEYBOARD keymap compiler (xkbcomp) reports:
> Warning:          Could not resolve keysym XF86CameraAccessEnable
> Warning:          Could not resolve keysym XF86CameraAccessDisable
> Warning:          Could not resolve keysym XF86CameraAccessToggle
> Warning:          Could not resolve keysym XF86NextElement
> Warning:          Could not resolve keysym XF86PreviousElement
> Warning:          Could not resolve keysym XF86AutopilotEngageToggle
> Warning:          Could not resolve keysym XF86MarkWaypoint
> Warning:          Could not resolve keysym XF86Sos
> Warning:          Could not resolve keysym XF86NavChart
> Warning:          Could not resolve keysym XF86FishingChart
> Warning:          Could not resolve keysym XF86SingleRangeRadar
> Warning:          Could not resolve keysym XF86DualRangeRadar
> Warning:          Could not resolve keysym XF86RadarOverlay
> Warning:          Could not resolve keysym XF86TraditionalSonar
> Warning:          Could not resolve keysym XF86ClearvuSonar
> Warning:          Could not resolve keysym XF86SidevuSonar
> Warning:          Could not resolve keysym XF86NavInfo
Errors from xkbcomp are not fatal to the X server
[2025-05-26 18:28:48] [INFO] Generating xauth entry for :14
[2025-05-26 18:28:48] [INFO] xauth entry generated
[2025-05-26 18:28:48] [INFO] DISPLAY set to :14
[2025-05-26 18:28:48] [INFO] Starting vncviewer on 192.168.4.104 (lane 4)
[2025-05-26 18:28:48] [INFO] vncviewer started with PID 1882
The XKEYBOARD keymap compiler (xkbcomp) reports:
> Warning:          Could not resolve keysym XF86CameraAccessEnable
> Warning:          Could not resolve keysym XF86CameraAccessDisable
> Warning:          Could not resolve keysym XF86CameraAccessToggle
> Warning:          Could not resolve keysym XF86NextElement
> Warning:          Could not resolve keysym XF86PreviousElement
> Warning:          Could not resolve keysym XF86AutopilotEngageToggle
> Warning:          Could not resolve keysym XF86MarkWaypoint
> Warning:          Could not resolve keysym XF86Sos
> Warning:          Could not resolve keysym XF86NavChart
> Warning:          Could not resolve keysym XF86FishingChart
> Warning:          Could not resolve keysym XF86SingleRangeRadar
> Warning:          Could not resolve keysym XF86DualRangeRadar
> Warning:          Could not resolve keysym XF86RadarOverlay
> Warning:          Could not resolve keysym XF86TraditionalSonar
> Warning:          Could not resolve keysym XF86ClearvuSonar
> Warning:          Could not resolve keysym XF86SidevuSonar
> Warning:          Could not resolve keysym XF86NavInfo
Errors from xkbcomp are not fatal to the X server
TigerVNC Viewer v1.13.1
Built on: 2024-04-01 08:26
Copyright (C) 1999-2022 TigerVNC Team and many others (see README.rst)
See https://www.tigervnc.org for information on TigerVNC.
Mon May 26 18:28:49 2025
XRequest.131: BadWindow (invalid Window parameter) 0x200005
[2025-05-26 18:28:53] [INFO] Starting ffmpeg capturing :14 and streaming to /home/user/vnc-hls/hls/lane4.m3u8
[2025-05-26 18:28:53] [INFO] ffmpeg started with PID 1918
Input #0, x11grab, from ':14':
[out#0/hls @ 0x5c06ef491900] Codec AVOption sc_threshold (Scene change threshold) has not been used for any stream. The most likely reason is either wrong type (e.g. a video option with no video streams) or that it is a private option of some encoder which was not actually used for any stream.
Stream mapping:
Press [q] to stop, [?] for help
Output #0, hls, to '/home/user/vnc-hls/hls/lane4.m3u8':
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_544.ts' for writing 
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_545.ts' for writing 
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_546.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_547.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_548.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_549.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_550.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_551.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_552.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_553.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_554.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_555.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
frame=  488 fps= 10 q=-0.0 size=N/A time=00:00:48.70 bitrate=N/A speed=   1x    
Mon May 26 18:29:43 2025
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4_556.ts' for writing
[hls @ 0x5c06ef492600] Opening '/home/user/vnc-hls/hls/lane4.m3u8.tmp' for writing
[200~vncviewer 192.168.4.104:5900
~
vncviewer 192.168.4.104:5900
cat > 4.sh << EOF
#!/bin/bash

# Lane 4 parameters (index 3)
FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IP="192.168.4.104"
DISPLAY_NUM=":14"

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LANE_NUM=4

# Kill related processes by display and IP (adjust grep if needed)
pkill -f "Xvfb $DISPLAY_NUM"
pkill -f "vncviewer.*$IP"
pkill -f "ffmpeg.*$DISPLAY_NUM"

sleep 2

# Start Xvfb
Xvfb "$DISPLAY_NUM" -screen 0 480x800x24 &
XVFB_PID=$!

sleep 2

# Generate Xauthority
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate "$DISPLAY_NUM" . trusted

export DISPLAY="$DISPLAY_NUM"

# Start vncviewer
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
VNC_PID=$!

sleep 5

# Setup ffmpeg stream paths
HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

# Start ffmpeg
ffmpeg -hide_banner -loglevel info   -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY_NUM"   -vaapi_device "$VAAPI_DEVICE"   -vf 'format=nv12,hwupload'   -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0   -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list   -hls_segment_filename "$HLS_SEGMENT_PATTERN"   "$HLS_PLAYLIST" &
FFMPEG_PID=$!

echo "[INFO] Restarted lane 4: Xvfb PID $XVFB_PID, vncviewer PID $VNC_PID, ffmpeg PID $FFMPEG_PID"

EOF

chmod +x 4.sh
./4.sh
ps
cat > 4n.sh << EOF
#!/bin/bash

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IP="192.168.4.104"
DISPLAY_NUM=":14"

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LANE_NUM=4

# Kill previous processes by display and IP
pkill -f "Xvfb $DISPLAY_NUM"
pkill -f "vncviewer.*$IP"
pkill -f "ffmpeg.*$DISPLAY_NUM"

sleep 2

# Start Xvfb without quotes on DISPLAY_NUM
Xvfb $DISPLAY_NUM -screen 0 480x800x24 &
XVFB_PID=$!

sleep 2

# Create Xauthority file and export it before running xauth
XAUTH_FILE=$(mktemp /tmp/.Xauthority.XXXXXX)
export XAUTHORITY="$XAUTH_FILE"
xauth generate $DISPLAY_NUM . trusted

export DISPLAY=$DISPLAY_NUM

# Start vncviewer
vncviewer -ViewOnly=1 -Fullscreen=1 "$IP:5900" -passwd /home/user/.vnc/passwd &
VNC_PID=$!

sleep 5

HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

ffmpeg -hide_banner -loglevel info   -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i $DISPLAY_NUM   -vaapi_device $VAAPI_DEVICE   -vf 'format=nv12,hwupload'   -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0   -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list   -hls_segment_filename "$HLS_SEGMENT_PATTERN"   "$HLS_PLAYLIST" &
FFMPEG_PID=$!

echo "[INFO] Restarted lane 4: Xvfb PID $XVFB_PID, vncviewer PID $VNC_PID, ffmpeg PID $FFMPEG_PID"

EOF

chmod +x 4n.sh
./4n.sh
nano 4n.sh
ping 192.168.4.104
./4n.sh
suddo reboot
sudo reboot
cat new.sh
ps
kill 1537
kill 1558
ls
ps
kill 1560
ls
sudo systemctl disable vnc-to-hls.service
sudo systemctl stop vnc-to-hls.sh
sudo reboot
cat > 345.sh < EOF
cat > 345.sh << EOF
#!/bin/bash
set -euo pipefail

FRAME_RATE=10
CAPTURE_RES=480x800
VAAPI_DEVICE="/dev/dri/renderD128"

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

HLS_BASE="/home/user/vnc-hls/hls"
PLAYLIST_PREFIX="lane"
LOG_DIR="/home/user/vnc-hls/logs"
mkdir -p "$LOG_DIR"

MAX_RETRIES=10
RETRY_DELAY=5  # seconds base delay, increases linearly per retry

# Function to check if IP is reachable
ping_check() {
  ping -c 1 -W 1 "$1" &>/dev/null
}

run_lane() {
  local IP=$1
  local DISPLAY_NUM=$2
  local LANE_NUM=$3
  local LOG_FILE="$LOG_DIR/lane${LANE_NUM}.log"

  local retry_count=0

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

      HLS_PLAYLIST="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}.m3u8"
      HLS_SEGMENT_PATTERN="$HLS_BASE/${PLAYLIST_PREFIX}${LANE_NUM}_%03d.ts"

      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Starting ffmpeg capturing $DISPLAY and streaming to $HLS_PLAYLIST"
      ffmpeg -hide_banner -loglevel info         -f x11grab -r $FRAME_RATE -s $CAPTURE_RES -i "$DISPLAY"         -vaapi_device "$VAAPI_DEVICE"         -vf 'format=nv12,hwupload'         -c:v h264_vaapi -b:v 1M -maxrate 1M -bufsize 2M -g 30 -sc_threshold 0         -hls_time 4 -hls_list_size 12 -hls_flags delete_segments+append_list         -hls_segment_filename "$HLS_SEGMENT_PATTERN"         "$HLS_PLAYLIST"

      # If ffmpeg exits, the script continues here:
      echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] ffmpeg exited unexpectedly, killing vncviewer and Xvfb"

      kill $VNC_PID $XVFB_PID || true
      wait $VNC_PID $XVFB_PID 2>/dev/null || true

      rm -f "$XAUTH_FILE"

      retry_count=$((retry_count + 1))

      if (( retry_count >= MAX_RETRIES )); then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] [WARN] Max retries reached on lane $LANE_NUM. Waiting 5 minutes before retrying..."
        sleep 300  # 5 minutes wait
        retry_count=0
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

chmod +x 345.sh
./345.sh
ls
./345.sh
rm 345.sh
nano 345.sh
rm 345.sh
nano 345.sh
chmod +x 345.sh
./345.sh
p
ps
rn
mv vnc-to-hls.sh vnc-to-hls-old.sh
mv 345.sh vnc-to-hls.sh
git push
ps
sudo reboot
sudo mkdir -p /var/www/html/vnc-status
sudo chown user:www-data /var/www/html/vnc-status
chmod 775 /var/www/html/vnc-status
sed -i '/ffmpeg started with PID/a \ \ \ \ echo "{\"status\":\"ok\",\"ip\":\"$IP\",\"last_updated\":\"$(date \x27+%Y-%m-%d %H:%M:%S\x27)\"}" > "/var/www/html/vnc-status/lane${LANE_NUM}.json"' 345.sh
sed -i '/retry_count=/a \ \ \ \ echo "{\"status\":\"error\",\"ip\":\"$IP\",\"message\":\"retry $retry_count\",\"last_updated\":\"$(date \x27+%Y-%m-%d %H:%M:%S\x27)\"}" > "/var/www/html/vnc-status/lane${LANE_NUM}.json"' 345.sh
ls
git commit -m "update"
git push
ls
git add .
git commit -m "Update all files with latest monitoring changes"
git push
