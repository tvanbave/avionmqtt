AvionMQTT (Docker Version)

AvionMQTT is a lightweight bridge between Avi-on Bluetooth mesh devices and Home Assistant via MQTT.

This version runs inside Docker and includes:
	•	Auto-discovery of lights in Home Assistant
	•	Friendly names and devices properly registered
	•	Simple web interface to view discovered devices
	•	Proper availability (online/offline) reporting to Home Assistant
	•	Graceful shutdown handling

 Features
	•	MQTT Auto-Discovery
Devices show up automatically in Home Assistant with correct names and icons.
	•	Web Dashboard
Basic device viewer available at http://<pi-ip>:5000/.
	•	Dockerized
No system packages or virtualenv needed — runs completely isolated.
	•	Bluetooth and DBus access
Uses host networking and privileged access for Bluetooth scanning.

Installation

Requirements
	•	Raspberry Pi (or any Linux host with BLE)
	•	Docker + Docker Compose
	•	Home Assistant with an MQTT broker (e.g., Mosquitto)

 Setup
	1.	Clone the repository
 	2.	Update settings.yaml
  Create or edit settings.yaml in the root directory:
avion:
  email: "your-avi-on-email"
  password: "your-avi-on-password"

mqtt:
  host: "mqtt-broker-ip"
  username: "your-mqtt-username"
  password: "your-mqtt-password"

	3.	Start the container
   docker compose up -d --build

   	4.	Access

	•	Web Dashboard:
http://yourip:5000/
	•	Devices will automatically appear in Home Assistant under Settings → Devices & Services → Devices.

Credits
	•	Based on the excellent work from fusioncha0s/avionmqtt
	•	Extended for full Docker support and Home Assistant improvements
