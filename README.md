AvionMQTT

AvionMQTT bridges Avi-on Bluetooth Mesh lights to MQTT for use in Home Assistant and other systems.

Now with Docker support and a built-in Flask web UI to view connected devices!

Features

🦿 Discovers Avi-on devices automatically

🔄 Publishes each Avi-on device as a separate MQTT Light in Home Assistant

📋 Auto-populates correct names, IDs, and capabilities (e.g., brightness, color temp)

👨‍🚀 Publishes MQTT availability topics (online/offline)

🐳 Runs easily inside Docker (with host networking and BLE support)

🌐 Web interface (/devices) to view discovered Avi-on devices

🛡️ Clean shutdown and resource management

Requirements

MQTT broker (e.g., Mosquitto)

Home Assistant (optional, but recommended)

Raspberry Pi 3/4 or any Linux server with BLE

Docker and Docker Compose installed

Installation

Clone the repository:

git clone https://github.com/yourusername/avionmqtt.git
cd avionmqtt

1. Configure settings

Create or edit settings.yaml:

avion:
  email: "your-avi-on-account@example.com"
  password: "your-password"

mqtt:
  host: "your-mqtt-broker.local"
  username: "mqtt-user"
  password: "mqtt-pass"

2. Build and run using Docker Compose

sudo docker compose up -d --build

Notes:

Must use network_mode: host (required for Bluetooth).

The container is marked privileged: true to allow BLE.

Settings are mounted into the container via a volume.

Accessing the Web UI

Once running, access the web interface to view detected devices:

http://<your-pi-ip>:5000/devices

Example:

http://192.168.1.83:5000/devices

Home Assistant Integration

Devices are discovered automatically via MQTT discovery.Each device will appear under Settings → Devices → Integrations → MQTT.

Example Entity:

light.master_closet_1

Each light publishes:

State topic: hmd/light/avid/<avid>/state

Command topic: hmd/light/avid/<avid>/command

Attributes topic: hmd/light/avid/<avid>/attributes

Availability topic: hmd/light/avid/<avid>/availability

Development Notes

Container runs Flask using the built-in server (for now).

In production, consider running Flask behind a WSGI server like gunicorn.

Full async event loop management using aiomqtt and Bleak.

TODO / Roadmap



License

MIT License

🚀 Quick Start Command Summary

git clone https://github.com/yourusername/avionmqtt.git
cd avionmqtt
nano settings.yaml
sudo docker compose up -d --build

Then visit: http://<your-ip>:5000/devices


