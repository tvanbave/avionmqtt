from flask import Flask, Response
from threading import Lock

app = Flask(__name__)
LOG_BUFFER = []
LOG_LOCK = Lock()
device_list = []

LOG_HTML = """
<html>
<head>
<title>AvionMQTT Logs</title>
<style>
body { background-color: #1e1e1e; color: #c7c7c7; font-family: monospace; }
pre { white-space: pre-wrap; word-wrap: break-word; }
span.debug { color: gray; }
span.info { color: lightgreen; }
span.warning { color: yellow; }
span.error { color: orange; }
span.critical { color: red; font-weight: bold; }
.controls { margin-bottom: 10px; }
</style>
<script>
function togglePause() {
    let paused = document.getElementById('pauseButton').dataset.paused === 'true';
    document.getElementById('pauseButton').dataset.paused = (!paused).toString();
    document.getElementById('pauseButton').innerText = (!paused) ? 'Resume' : 'Pause';
}

function refreshLogs() {
    if (document.getElementById('pauseButton').dataset.paused === 'true') return;
    fetch('/logs')
        .then(response => response.text())
        .then(data => document.getElementById('logContainer').innerHTML = data);
}

setInterval(refreshLogs, 2000);
</script>
</head>
<body>
<div class="controls">
<button id="pauseButton" data-paused="false" onclick="togglePause()">Pause</button>
</div>
<pre id="logContainer">Loading...</pre>
</body>
</html>
"""

@app.route('/')
def index():
    return LOG_HTML

@app.route('/logs')
def logs():
    with LOG_LOCK:
        content = "\n".join(LOG_BUFFER[-500:])
    return Response(content, mimetype='text/plain')

def start_webserver():
    app.run(host="0.0.0.0", port=5000)
