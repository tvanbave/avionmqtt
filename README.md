# AvionMQTT

Avi-on Cooper Halo Home to MQTT Bridge.

Now with:
- 🚀 Docker support
- 🏠 Automatic Home Assistant MQTT Discovery
- 🌐 Basic built-in Web Server for viewing connected devices
- Proper device names

---

## Quick Start

### 1. Install Docker on your Raspberry Pi (or any Linux)

```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Install Docker Compose plugin (optional):

```bash
sudo apt install docker-compose-plugin
```

---

### 2. Clone the repository

```bash
git clone https://github.com/tvanbave/avionmqtt.git
cd avionmqtt
```

---

### 3. Set up your settings.yaml

Create `settings.yaml` based on your environment. Example:

```yaml
avion:
  email: "your-email@example.com"
  password: "your-avion-password"

mqtt:
  host: "your-mqtt-broker"
  username: "your-mqtt-username"
  password: "your-mqtt-password"

devices:
  import: true
  include: []
  exclude: []
  exclude_in_group: false

groups:
  import: true
  include: []
  exclude: []
```

---

### 4. Build and run with Docker Compose

```bash
sudo docker compose up -d --build
```

The container will automatically:
- Connect to Avi-on
- Discover your devices
- Publish MQTT discovery topics
- Serve a basic web UI at `http://<your-pi-ip>:5000`

---

## Notes

- `network_mode: host` and `privileged: true` are required for BLE scanning.
- BLE scanning inside Docker uses `/var/run/dbus`.
- Web server shows device names, MACs, and product IDs.
- Lights automatically appear in Home Assistant with friendly names.
- MQTT availability topic (`online`/`offline`) is also published.

---

## Home Assistant Discovery

Entities are created automatically using the device name as the `object_id`.  
They are shown as standard MQTT lights.

Each device is created as a separate device in Home Assistant, not grouped under a bridge.

Example entity name:
```text
light.master_closet_1
```

---

## Web Server

While the bridge runs, you can view your device list here:

```text
http://<your-pi-ip>:5000/devices
```

Example output:

```json
[
  {"name": "Master Closet 1", "mac_address": "1c:d6:bd:90:68:cd", "product_id": 93},
  {"name": "Master Closet 2", "mac_address": "1c:d6:bd:9a:34:a8", "product_id": 93}
]
```

---

## Changes from the Original

- Dockerized (`Dockerfile` and `docker-compose.yml`).
- Home Assistant MQTT Discovery integration.
- Friendly `object_id` and `name` generation from light names.
- Separate device registrations for each light.
- Added availability ("online") MQTT topic.
- Flask web server for device listing.

---

## Todo

- Web interface for controlling devices.
- Improved error handling and reconnect logic.

---

## License

MIT License
