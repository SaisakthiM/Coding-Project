#!/bin/bash

# ===============================
# WSL2 + Tinyproxy + Docker Setup
# ===============================

# Step 1: Install tinyproxy if not installed
if ! command -v tinyproxy >/dev/null 2>&1; then
    echo "[*] Installing tinyproxy..."
    sudo apt update && sudo apt install -y tinyproxy
fi

# Step 2: Configure tinyproxy
echo "[*] Configuring tinyproxy..."
sudo tee /etc/tinyproxy/tinyproxy.conf > /dev/null <<EOF
User nobody
Group nogroup
Port 8888
Listen 127.0.0.1
Timeout 600
LogLevel Info
MaxClients 100
MinSpareServers 5
MaxSpareServers 20
StartServers 10
PidFile "/var/run/tinyproxy/tinyproxy.pid"
Allow 127.0.0.1
EOF

# Step 3: Start tinyproxy in background
echo "[*] Starting tinyproxy..."
sudo nohup tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d > ~/tinyproxy.log 2>&1 &

# Step 4: Fix DNS for WSL2
echo "[*] Configuring resolv.conf for Google DNS..."
sudo bash -c 'echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf'
sudo chattr +i /etc/resolv.conf

# Step 5: Configure Docker daemon to use proxy
DOCKER_CONFIG='/etc/docker/daemon.json'
echo "[*] Configuring Docker daemon for proxy..."
sudo mkdir -p /etc/docker
sudo tee $DOCKER_CONFIG > /dev/null <<EOF
{
  "proxies": {
    "default": {
      "httpProxy": "http://127.0.0.1:8888",
      "httpsProxy": "http://127.0.0.1:8888",
      "noProxy": "localhost,127.0.0.1"
    }
  }
}
EOF

# Step 6: Restart Docker Desktop (Windows) and WSL
echo "[*] Restart WSL2..."
wsl --shutdown

echo "[*] Setup complete!"
echo "Run 'docker pull hello-world' after restarting Docker Desktop."
