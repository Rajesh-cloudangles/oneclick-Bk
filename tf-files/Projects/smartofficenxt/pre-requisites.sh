#!/bin/bash


echo "#TAG800#"

# ----------------------------------------
# Update package lists
# ----------------------------------------
sudo apt update -y

# ----------------------------------------
# Nginx Installation
# ----------------------------------------
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Move to NGINX directory and enable site
sudo mv /home/ubuntu/default /etc/nginx/sites-available/default
sudo chmod 644 /etc/nginx/sites-available/default
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found, installing..."
    sudo apt-get update -y
    sudo apt-get install -y unzip curl
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    echo "AWS CLI installed successfully"
else
    echo "AWS CLI is already installed: $(aws --version)"
fi

echo "✅ System setup complete. Proceeding with artifact deployment..."


echo "#TAG801#"

sleep 20

echo "#TAG802#"

# Variables for artifact fetch
ARTIFACTS_PATH="s3://github-artifacts-ca/$PROJECT_NAME/$RELEASE_VERSION/"
TARGET_DIR="/home/ubuntu/$PROJECT_NAME-artifacts"

# Create directory and fetch artifacts
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
aws s3 cp --recursive "$ARTIFACTS_PATH" .

sudo chmod o+x /home
sudo chmod o+x /home/ubuntu
sudo chmod -R o+rX /home/ubuntu/smartofficenxt-artifacts

echo "#TAG803#"