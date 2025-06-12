
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
echo "#TAG105#"

# Update package lists
sudo apt update -y
sudo apt upgrade -y

# Install prerequisites
sudo apt install -y software-properties-common

# Ansible Inventory Setup
# ----------------------------------------
sudo touch /home/ubuntu/inventory.ini
echo "[webserver]" | sudo tee /home/ubuntu/inventory.ini
echo "localhost ansible_connection=local" | sudo tee -a /home/ubuntu/inventory.ini
sudo chown ubuntu:ubuntu /home/ubuntu/inventory.ini  # Set ownership for 'ubuntu' user

# ----------------------------------------

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


echo "#OPS305#"


# Add deadsnakes PPA for newer Python versions
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y


# Install required Python version and dependencies
sudo apt install -y python3.10 python3.10-venv python3.10-dev python3.10-distutils

# Ensure the correct venv package is installed
sudo apt install -y python3-venv

# ----------------------------------------
# Ansible Installation
# ----------------------------------------
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# # Create virtual environment
# python3 -m venv /mnt/user-data/mlops_Code_Generation/venv

# # Set Python 3.10 as default (if needed)
# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
# sudo update-alternatives --config python3  # Choose the correct version if prompted

# Set Python 3.10 as default non-interactively
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10
sudo update-alternatives --set python3 /usr/bin/python3.10
echo "#OPS306#"
# Verify Installation
python3 --version

echo "Python 3.10 installation completed successfully!"

echo "#TAG106#"


