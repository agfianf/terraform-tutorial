#!/bin/bash

# Fetch metadata dari GCP
INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
INSTANCE_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
HOSTNAME=$(hostname)

echo "[GITLAB] Instance Name: $INSTANCE_NAME"
echo "[GITLAB] Instance IP: $INSTANCE_IP"
echo "[GITLAB] Hostname: $HOSTNAME"

# https://about.gitlab.com/install/#ubuntu
# Update sistem
echo "[GITLAB] Updating system..."
apt-get update && apt-get upgrade -y

# Install dependencies
echo "[GITLAB] Installing dependencies..."
apt-get install -y curl ca-certificates gnupg nano

# Ubah port SSH VM ke 2222
echo "[GITLAB] Configuring SSH to use port 2222..."
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
if ! systemctl restart ssh; then
  echo "[GITLAB] Failed to restart SSH, retrying..."
  sleep 5
  systemctl restart ssh
fi

# install docker
echo "[GITLAB] Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

usermod -aG docker $USER

# Install Docker Compose
echo "[GITLAB] Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Buat direktori untuk GitLab
echo "[GITLAB] Creating GitLab directories..."
mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs

echo "[GITLAB] Creating docker-compose.yml"
cat << EOF > /srv/gitlab/docker-compose.yml
services:
  gitlab:
    container_name: gitlab-server
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: '$HOSTNAME'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://$INSTANCE_IP'
        gitlab_rails['gitlab_shell_ssh_port'] = 22
    ports:
      - 80:80
      - 22:22 # SSH GIT di port 22
    volumes:
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
    shm_size: '256m'
EOF

# Jalankan Docker Compose
echo "[GITLAB] Starting GitLab with Docker Compose..."
cd /srv/gitlab
sudo systemctl restart ssh
source ~/.bashrc
sudo docker-compose up -d

echo "[GITLAB] Waiting for GitLab to start..."
sleep 600 # wait for 5 minutes
sudo docker-compose logs gitlab-server

echo "[GITLAB] password root:"
sudo docker exec -it gitlab-server grep 'Password:' /etc/gitlab/initial_root_password

echo "[GITLAB] Installation completed!"