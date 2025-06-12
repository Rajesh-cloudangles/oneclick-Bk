#!/bin/bash
UBUNTU_PASSWORD="1Lk73964RZUBnZR6BNz7T74icPFfmuLeNb"
set -e

# Update and clean packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold upgrade -y
sudo apt-get autoremove -y && sudo apt-get autoclean -y
sudo snap refresh

sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y sshpass
sudo mkdir -p /etc/needrestart/conf.d
echo -e '$nrconf{restart} = "a";\n$nrconf{kernelhints} = 0;' | sudo tee /etc/needrestart/conf.d/99my.conf
sudo /usr/sbin/needrestart -r a || true


sudo chmod 644 /etc/environment

# Install required packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
    liblzma-dev python3-openssl git unzip python3-venv

# Fetch EC2 instance metadata token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Get public IP
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

# Persist environment variables
echo "UBUNTU_PASSWORD=$UBUNTU_PASSWORD" | sudo tee -a /etc/environment
echo "PUBLIC_IP=$PUBLIC_IP" | sudo tee -a /etc/environment

# Enable password-based SSH login
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
sudo systemctl restart sshd

# Set Ubuntu user password
echo "ubuntu:$UBUNTU_PASSWORD" | sudo chpasswd

# Add instance's public IP to known hosts
ssh-keyscan -H "$PUBLIC_IP" >> ~/.ssh/known_hosts

# Install pyenv
curl https://pyenv.run | bash

# Add pyenv config to shell
cat <<EOF >> ~/.bashrc

## PYENV CONFIG ##
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
## END PYENV CONFIG ##
EOF

# Export for current session (non-interactive)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install Python 3.9.19 if not present
if ! pyenv versions | grep -q "3.9.19"; then
    pyenv install -v 3.9.19
fi
pyenv global 3.9.19

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

set -a
source_env_file="/etc/environment"
if [ -r "$source_env_file" ]; then
  while IFS='=' read -r key value; do
    case "$key" in
      ''|\#*) continue ;;
    esac
    export "$key=$value"
  done < "$source_env_file"
else
  echo "Warning: Cannot read $source_env_file"
fi
set +a

cat /etc/environment 
sleep 10

# Variables for artifact fetch
ARTIFACTS_PATH="s3://github-artifacts-ca/$PROJECT_NAME/$RELEASE_VERSION/"
TARGET_DIR="/home/ubuntu/$PROJECT_NAME-artifacts"

# Create directory and fetch artifacts
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
aws s3 cp --recursive "$ARTIFACTS_PATH" .

# Change into project directory (assumes optscale-deploy exists in artifacts)
cd optscale-deploy/

# Create Python virtual environment
python3 -m venv .venv
. .venv/bin/activate

# Install project dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Load environment variables again if needed
. /etc/environment

# Run Ansible playbook
./.venv/bin/python3 -m ansible.cli.playbook \
  -i "${PUBLIC_IP}," \
  -e "ansible_ssh_user=ubuntu ansible_ssh_pass=$UBUNTU_PASSWORD ansible_become_pass=$UBUNTU_PASSWORD" \
  --ssh-extra-args="-o StrictHostKeyChecking=no" \
  --connection=ssh --timeout=30 \
  ansible/k8s-master.yaml

# Run deployment script
./runkube.py --with-elk -o overlay/user_template.yml -- optscale 6adebfabc29f8724113ea836d7676bf8e6a1535f

echo "✅ Deployment completed successfully"
