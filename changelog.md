Changelog

v2.0.0 (Dockerized Version)

Major Changes
	•	Migrated AvionMQTT to Docker with docker-compose support
	•	Added web dashboard (Flask) to list Avi-on devices
	•	Implemented friendly names and object IDs for Home Assistant auto-discovery
	•	Devices now show up properly as individual Home Assistant Devices, not just entities under a bridge
	•	Added MQTT availability (online/offline) reporting for better status tracking
	•	Built-in graceful shutdown to disconnect cleanly
	•	Slim, lightweight Docker image based on python:3.11-slim

Technical Improvements
	•	No system-wide venv required
	•	Host Bluetooth access handled with network_mode: host and privileged: true
	•	Settings provided through settings.yaml mount
	•	Optimized MQTT topics for Home Assistant

⸻

Coming Soon
	•	Optional real-time device control and updates via web UI
	•	Optimized DBus handling inside the container
