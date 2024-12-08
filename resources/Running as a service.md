# Running avionmqtt as a service

This is based on the guide from https://github.com/torfsen/python-systemd-tutorial.

---

This script represents the steps taken and has not been verified to run as written below.
```bash
#!/bin/bash
# prepare user to run as
sudo useradd -r -s /bin/false avion_mqtt
# prepare venv
$ sudo mkdir /usr/local/lib/avionmqtt && cd /usr/local/lib/avionmqtt
$ sudo python3 -m venv .venv && sudo .venv/bin/python -m pip install avionmqtt
# create the service
$ cat <<EOF > /etc/systemd/system/avionmqtt.service
[Unit]
Description=avion mqtt bridge

[Service]
ExecStart=/usr/local/lib/avionmqtt/.venv/bin/python -m avionmqtt -s /usr/local/lib/avionmqtt/settings.yaml
Restart=on-failure
User=avion_mqtt

[Install]
WantedBy=default.target
EOF
# reolad the services
$ sudo systemctl daemon-reload
# now create settings.yaml
$ sudo vim /user/local/lib/avionmqtt/settings.yaml
# start the service
$ sudo systemctl restart avionmqtt
 ```