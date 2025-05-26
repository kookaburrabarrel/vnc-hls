      border: 1px solid #666;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background: #555;
    }
  </style>
</head>
<body>

  <div class="stream">
    <video id="video11" muted autoplay playsinline></video>
    <button onclick="interact('192.168.4.101', 6081)">Interact</button>
  </div>
  <div class="stream">
    <video id="video12" muted autoplay playsinline></video>
    <button onclick="interact('192.168.4.102', 6082)">Interact</button>
  </div>
  <div class="stream">
    <video id="video13" muted autoplay playsinline></video>
    <button onclick="interact('192.168.4.103', 6083)">Interact</button>
  </div>
  <div class="stream">
    <video id="video14" muted autoplay playsinline></video>
    <button onclick="interact('192.168.4.104', 6084)">Interact</button>
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
      } else if (Hls.isSupported()) {
        const hls = new Hls();
        hls.loadSource(url);
        hls.attachMedia(video);
      } else {
        console.error("HLS not supported in this browser");
      }
    });

    function interact(host, port) {
      // Assumes noVNC is hosted at /vnc.html on that port
      const url = `http://${host}:${port}/vnc.html`;
      window.open(url, '_blank');
    }
  </script>

</body>
</html>

EOF

sudo pip3 install websockify
sudo apt update
sudo apt install websockify
cd /var/www/html
sudo git clone https://github.com/novnc/noVNC.git
sudo netstat -tulpn | grep 6081
cd /var/www/html/noVNC
sudo websockify --web . 6081 192.168.4.101:5900
cd /var/www/html/noVNC
sudo websockify --web . 6081 192.168.4.101:5900
cd vnc-hls
ls
cat > hmmm.html << EOF
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
    gap: 20px;
    font-family: Arial, sans-serif;
    flex-wrap: wrap;
  }
  .video-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  video {
    width: 240px; /* half of 480 */
    height: 400px; /* half of 800 */
    background: black;
    border: 2px solid #444;
    border-radius: 6px;
    pointer-events: none; /* disable interaction on video */
  }
  button {
    margin-top: 6px;
    padding: 6px 12px;
    border-radius: 4px;
    border: none;
    background-color: #337ab7;
    color: white;
    cursor: pointer;
    font-size: 14px;
  }
  button:hover {
    background-color: #286090;
  }
</style>
</head>
<body>

<div class="video-container">
  <video id="video11" muted autoplay playsinline></video>
  <button onclick="interact('video11')">Interact</button>
</div>

<div class="video-container">
  <video id="video12" muted autoplay playsinline></video>
  <button onclick="interact('video12')">Interact</button>
</div>

<div class="video-container">
  <video id="video13" muted autoplay playsinline></video>
  <button onclick="interact('video13')">Interact</button>
</div>

<div class="video-container">
  <video id="video14" muted autoplay playsinline></video>
  <button onclick="interact('video14')">Interact</button>
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
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
    } else {
      console.error("HLS not supported in this browser");
    }
  });

  // Hardcoded server IP, ports, and password
  const vncServerIP = "192.168.253.37";
  const websockifyPort = 6081; // noVNC port
  const vncPort = 5900;
  const vncPassword = encodeURIComponent("wuotu1Iocheegi6u");

  function interact(videoId) {
    // Open noVNC client in a new popup window with auto-connect and password
    const url = `http://${vncServerIP}:${websockifyPort}/vnc.html?host=${vncServerIP}&port=${vncPort}&autoconnect=true&password=${vncPassword}`;
    window.open(url, '_blank', 'width=900,height=600');
  }
</script>

</body>
</html>

EOF

ls
nano hmmm.html
sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
    gap: 20px;
    font-family: Arial, sans-serif;
    flex-wrap: wrap;
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
  button {
    margin-top: 6px;
    padding: 6px 12px;
    border-radius: 4px;
    border: none;
    background-color: #337ab7;
    color: white;
    cursor: pointer;
    font-size: 14px;
  }
  button:hover {
    background-color: #286090;
  }
</style>
</head>
<body>

<div class="video-container">
  <video id="video11" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video12" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video13" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video14" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
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
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
    } else {
      console.error("HLS not supported in this browser");
    }
  });

  function interact() {
    const vncServerIP = "192.168.253.37";
    const websockifyPort = 6081;
    const vncPort = 5900;
    const vncPassword = encodeURIComponent("wuotu1Iocheegi6u");
    const url = `http://${vncServerIP}:${websockifyPort}/vnc.html?host=${vncServerIP}&port=${vncPort}&autoconnect=true&password=${vncPassword}`;
    window.open(url, '_blank', 'width=480,height=800');
  }
</script>

</body>
</html>
EOF

sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
      gap: 20px;
      font-family: Arial, sans-serif;
      flex-wrap: wrap;
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
    button {
      margin-top: 6px;
      padding: 6px 12px;
      border-radius: 4px;
      border: none;
      background-color: #337ab7;
      color: white;
      cursor: pointer;
      font-size: 14px;
    }
    button:hover {
      background-color: #286090;
    }
  </style>
</head>
<body>

<div class="video-container">
  <video id="video11" muted autoplay playsinline></video>
  <button class="interact-button">Interact</button>
</div>

<div class="video-container">
  <video id="video12" muted autoplay playsinline></video>
  <button class="interact-button">Interact</button>
</div>

<div class="video-container">
  <video id="video13" muted autoplay playsinline></video>
  <button class="interact-button">Interact</button>
</div>

<div class="video-container">
  <video id="video14" muted autoplay playsinline></video>
  <button class="interact-button">Interact</button>
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
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
    } else {
      console.error("HLS not supported in this browser");
    }
  });

  const server = "192.168.253.37";
  const wsPort = 6081;
  const vncPort = 5900;
  const password = encodeURIComponent("wuotu1Iocheegi6u");

  document.querySelectorAll(".interact-button").forEach(button => {
    button.addEventListener("click", () => {
      const url = `http://${server}:${wsPort}/vnc.html?autoconnect=true&resize=scale&host=${server}&port=${vncPort}&password=${password}`;
      window.open(url, "_blank", "popup,width=480,height=800,menubar=no,toolbar=no,location=no,status=no");
    });
  });
</script>

</body>
</html>
EOF

sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
    gap: 20px;
    font-family: Arial, sans-serif;
    flex-wrap: wrap;
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
  button {
    margin-top: 6px;
    padding: 6px 12px;
    border-radius: 4px;
    border: none;
    background-color: #337ab7;
    color: white;
    cursor: pointer;
    font-size: 14px;
  }
  button:hover {
    background-color: #286090;
  }
</style>
</head>
<body>

<div class="video-container">
  <video id="video11" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video12" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video13" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
</div>

<div class="video-container">
  <video id="video14" muted autoplay playsinline></video>
  <button onclick="interact()">Interact</button>
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
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(url);
      hls.attachMedia(video);
    } else {
      console.error("HLS not supported in this browser");
    }
  });

  function interact() {
    const vncServerIP = "192.168.253.37";
    const websockifyPort = 6081;
    const vncPort = 5900;
    const vncPassword = encodeURIComponent("wuotu1Iocheegi6u");
    const url = `http://${vncServerIP}:${websockifyPort}/vnc.html?host=${vncServerIP}&port=${vncPort}&autoconnect=true&password=${vncPassword}`;
    window.open(url, '_blank', 'width=480,height=800');
  }
</script>

</body>
</html>
EOF

sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
  <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank"
     onclick="window.open(this.href, '_blank', 'width=480,height=800'); return false;">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_12/stream.m3u8"></video>
  <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank"
     onclick="window.open(this.href, '_blank', 'width=480,height=800'); return false;">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_13/stream.m3u8"></video>
  <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank"
     onclick="window.open(this.href, '_blank', 'width=480,height=800'); return false;">
    Interact
  </a>
</div>

<div class="video-container">
  <video muted autoplay playsinline src="/hls_display_14/stream.m3u8"></video>
  <a class="button" href="http://192.168.253.37:6081/vnc.html?autoconnect=true&resize=scale&host=192.168.253.37&port=5900&password=wuotu1Iocheegi6u"
     target="_blank"
     onclick="window.open(this.href, '_blank', 'width=480,height=800'); return false;">
    Interact
  </a>
</div>

</body>
</html>
EOF

sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
cd vnc-hls
ls
nano new.html
cat > nano.html << EOF
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
nano new.html
rm new.html
ls
sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
sudo tee /var/www/html/new.html > /dev/null << 'EOF'
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
cd ..
ls
cd ..
ls
cd user
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
