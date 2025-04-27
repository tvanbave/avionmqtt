from flask import Flask, jsonify

# We will populate this list from your main program
device_list = []

app = Flask(__name__)

@app.route("/devices")
def devices():
    """Return a list of devices as JSON."""
    return jsonify(device_list)

def start_webserver():
    """Start Flask app."""
    app.run(host="0.0.0.0", port=5000)
