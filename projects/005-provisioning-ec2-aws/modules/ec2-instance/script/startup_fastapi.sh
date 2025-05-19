#!/bin/bash

# Update system
echo "[APP] Updating system packages..."
apt-get update && apt-get upgrade -y

# Install prerequisites
echo "[APP] Installing prerequisites..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# install docker
echo "[APP] Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Install Docker Compose
echo "[APP] Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Test Docker with a simple hello-world container
echo "[APP] Running a test container..."
docker run --rm hello-world