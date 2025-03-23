#!/bin/bash


INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
INSTANCE_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
HOSTNAME=$(hostname)

echo "Update system packages..."
sudo apt update || { echo "Failed to update packages"; exit 1; }


echo "Installing nginx..."
sudo apt install -y nginx || { echo "Failed to install nginx"; exit 1; }


echo "Starting and enabling nginx service..."
sudo systemctl start nginx || { echo "Failed to start nginx"; exit 1; }
sudo systemctl enable nginx || { echo "Failed to enable nginx"; exit 1; }


cat << EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Instance Info</title>
</head>
<body>
    <h1>Instance Information</h1>
    <p>Instance Name: $INSTANCE_NAME</p>
    <p>Hostname: $HOSTNAME</p>
    <p>Instance IP: $INSTANCE_IP</p>

    <a href="https://agfianf.github.io/about/" target="_blank">About Agfian</a>
</body>
</html>
EOF


echo "Set permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html || { echo "Failed to change ownership"; exit 1; }
sudo chmod -R 755 /var/www/html || { echo "Failed to change permissions"; exit 1; }

echo "Nginx setup completed for instance: $INSTANCE_NAME (Hostname: $HOSTNAME)"

