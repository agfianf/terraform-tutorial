#!/bin/bash

# Fetch metadata dari GCP
INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
INSTANCE_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
HOSTNAME=$(hostname)

echo "[JENKINS] Instance Name: $INSTANCE_NAME"
echo "[JENKINS] Instance IP: $INSTANCE_IP"
echo "[JENKINS] Controller IP: $CONTROLLER_IP"
echo "[JENKINS] Hostname: $HOSTNAME"

echo "[JENKINS] Starting Jenkins Agent provisioning..."

# Update dan install dependencies
echo "[JENKINS] Updating system packages..."
apt-get update
apt-get install -y --no-install-recommends \
    openjdk-21-jdk \
    git \
    wget \
    curl

# Controller dan agent details dari Terraform template
CONTROLLER_IP="${controller_ip}"
CONTROLLER_URL="http://$${CONTROLLER_IP}:8080"
AGENT_NAME="${agent_name}"
AGENT_SECRET="${agent_secret}"

# Buat remote root directory
echo "[JENKINS] Creating remote root directory..."
mkdir -p /home/jenkins/agent-workspace
chmod 755 /home/jenkins/agent-workspace

# Tunggu controller siap (port 8080)
echo "[JENKINS] Waiting for Jenkins Controller to be ready at $CONTROLLER_IP:8080..."
until curl -s "$${CONTROLLER_URL}" --output /dev/null --write-out "%%{http_code}" | grep -qE "^(200|403)"; do
  echo "[JENKINS] Controller not ready yet, waiting 10 seconds..."
  sleep 10
done
echo "[JENKINS] Jenkins Controller is ready!"

# Download agent.jar
echo "[JENKINS] Downloading agent.jar..."
wget -O /home/jenkins/agent.jar "$${CONTROLLER_URL}/jnlpJars/agent.jar"

# Simpan secret ke file
echo "$${AGENT_SECRET}" > /home/jenkins/secret-file

# Jalankan agent dengan WebSocket
echo "[JENKINS] Starting Jenkins Agent..."
java -jar /home/jenkins/agent.jar -url "$${CONTROLLER_URL}/" -secret @/home/jenkins/secret-file -name "$${AGENT_NAME}" -webSocket -workDir "/home/jenkins/agent-workspace" &

echo "[JENKINS] Jenkins agent is running in the background."