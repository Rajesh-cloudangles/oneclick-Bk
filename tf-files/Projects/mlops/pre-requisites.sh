#!/bin/bash

# ----------------------------------------
# Update package lists
# ----------------------------------------
sudo apt update -y
sudo apt install tree -y

echo "#TAG100#"

# ----------------------------------------
# Ansible Installation
# ----------------------------------------
sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible 
# ----------------------------------------
# AWS CLI Installation
# ----------------------------------------
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found, installing..."
    sudo apt install -y unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip
    echo "AWS CLI installed successfully"
else
    echo "AWS CLI is already installed: $(aws --version)"
fi
# ----------------------------------------
# Install Golang
# ----------------------------------------
wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
tar -C /mnt/user-data -xzf go1.21.1.linux-amd64.tar.gz
rm go1.21.1.linux-amd64.tar.gz


# Fix permissions for the Go installation
sudo chown -R $(whoami):$(whoami) /mnt/user-data/go
sudo chmod -R 755 /mnt/user-data/go

echo 'export PATH="/mnt/user-data/go/bin:$PATH"' >> ~/.bashrc
echo 'export GOROOT="/mnt/user-data/go"' >> ~/.bashrc
echo 'export GOPATH="$HOME/go"' >> ~/.bashrc
echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc

# ----------------------------------------
# Node.js (Latest) Installation
# ----------------------------------------
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt install -y nodejs



# ----------------------------------------
# Nginx Installation
# ----------------------------------------
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx


# ----------------------------------------
# Docker Installation
# ----------------------------------------
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu  # Add 'ubuntu' user to Docker group


# ----------------------------------------
# Docker Compose Installation
# ----------------------------------------
sudo apt install -y docker-compose-plugin
sudo chmod +x /usr/local/bin/docker-compose
docker compose version  # Verify installation


# ----------------------------------------
# Python and MySQL Dependencies & Utility Tools
# ----------------------------------------
export DEBIAN_FRONTEND=noninteractive

# Ensure services restart automatically if needed
sudo sed -i 's/#\$nrconf{restart} =.*/\$nrconf{restart} = '\''a'\'';/g' /etc/needrestart/needrestart.conf


sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install -y python3.10 python3.10-venv python3.10-distutils
echo "#OPS510#"
sudo apt install -y python3-pip python3-dev libmysqlclient-dev python3-pymysql zip unzip jq


# ----------------------------------------
# Configure Docker Data Storage
# ----------------------------------------
sudo mkdir -p /mnt/user-data/docker
sudo bash -c 'cat << EOF > /etc/docker/daemon.json
{
  "data-root": "/mnt/user-data/docker"
}
EOF'
sudo systemctl restart docker

# ----------------------------------------
# Ansible Inventory Setup
# ----------------------------------------
sudo touch /home/ubuntu/inventory.ini
echo "[webserver]" | sudo tee /home/ubuntu/inventory.ini
echo "localhost ansible_connection=local" | sudo tee -a /home/ubuntu/inventory.ini
    # Set ownership for 'ubuntu' user

# ----------------------------------------
# Nginx Configuration
# ----------------------------------------


# Move to NGINX directory and enable site
sudo mv /home/ubuntu/default /etc/nginx/sites-available/default
sudo chmod 644 /etc/nginx/sites-available/default
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/


echo "Starting wait..."

for i in $(seq 1 10); do
  echo "Waiting... $((i * 20)) seconds passed"
  sleep 20
done

echo "Wait complete."

# sudo apt install -y certbot python3-certbot-nginx
# sudo certbot --nginx -d ${var.domain} --agree-tos --no-eff-email --email ${var.email}  --non-interactive
# sudo sed -i 's|root /var/www/html;|root ${var.nginx_root_path};|g' /etc/nginx/sites-available/default
# sudo systemctl reload nginx

# # ----------------------------------------
# # SSL Certificate Setup from S3
# # ----------------------------------------
# aws s3 cp s3://automation-ssl/automation_mlangles.ai_certs.zip /home/ubuntu/
# unzip automation_mlangles.ai_certs.zip -d /home/ubuntu/
# sudo mkdir -p /etc/letsencrypt/live/automation.mlangles.ai/
# sudo mv /home/ubuntu/fullchain.pem /home/ubuntu/privkey.pem /home/ubuntu/cert.pem /etc/letsencrypt/live/automation.mlangles.ai/
# rm -rf automation_mlangles.ai_certs.zip  # Clean up downloaded files

# #------------------------------------------------------------------
# # Set directory and file permissions for SSL certificates
# #------------------------------------------------------------------
# sudo chmod 755 /etc/letsencrypt
# sudo chmod 700 /etc/letsencrypt/live
# sudo chmod 755 /etc/letsencrypt/live/automation.mlangles.ai
# sudo chmod 600 /etc/letsencrypt/live/automation.mlangles.ai/privkey.pem
# sudo chmod 644 /etc/letsencrypt/live/automation.mlangles.ai/fullchain.pem
# sudo chmod 644 /etc/letsencrypt/live/automation.mlangles.ai/cert.pem
# sudo chown ubuntu:ubuntu /etc/letsencrypt/live/automation.mlangles.ai/


echo "#TAG101#"