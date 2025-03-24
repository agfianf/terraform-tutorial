#!/bin/bash

INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
INSTANCE_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
HOSTNAME=$(hostname)

echo "Instance Name: $INSTANCE_NAME"
echo "Instance IP: $INSTANCE_IP"
echo "Hostname: $HOSTNAME"

echo "Starting Jenkins provisioning..."

echo "Updating system packages..."
apt-get update
apt-get install -y --no-install-recommends apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    wget \
    openjdk-21-jdk

# install docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

usermod -aG docker $USER


java -version

echo "Installing Jenkins..."
# -- install jenkins
#  Start by importing the GPG key. The GPG key verifies package integrity
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# Add the Jenkins software repository to the source list and provide the authentication key:
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update
apt-get install -y jenkins
systemctl enable jenkins

usermod -aG docker jenkins
systemctl restart jenkins

echo "Jenkins is installed and running."
echo "Jenkins URL: http://$INSTANCE_IP:8080"
echo "Jenkins initial setup is required. Please visit the URL above to complete the setup."