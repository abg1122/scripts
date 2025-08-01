#!/bin/bash

# prometheus_exporter_setup.sh
# Installs and runs Prometheus node_exporter on a Linux host

# Author: abg1122

VERSION="1.8.1"
USER="node_exporter"

# --- Create system user ---
sudo useradd --no-create-home --shell /bin/false $USER

# --- Download and extract ---
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
tar -xvf node_exporter-${VERSION}.linux-amd64.tar.gz

# --- Move binaries ---
sudo cp node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo chown $USER:$USER /usr/local/bin/node_exporter

# --- Create systemd service ---
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=${USER}
Group=${USER}
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# --- Start and enable ---
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# --- Final output ---
echo "✅ node_exporter is running. Listening on port 9100"
