# Create an EC2 instance
resource "aws_instance" "instance" {
  ami           = var.ami # Ubuntu 22.04 AMI (Update if needed)
  instance_type = var.instance_type
  key_name      = "${var.project_name}-${var.env}-keypair"  # Ensure this key exists in AWS Mlops
  subnet_id      = aws_subnet.publicsubnet.id
  vpc_security_group_ids = [aws_security_group.ec2securitygroup.id] # Security Group
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  depends_on = [null_resource.mlops_gpu_dependency]
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-application"
  })

  root_block_device {
    volume_size           = var.primarydisksize
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-root-volume"
    })


  }
  # Attach a secondary EBS volume (20GB in this case)
  ebs_block_device {
    device_name           = "/dev/xvdb"  # Secondary volume device name
    volume_size           = var.secondarydisksize     # Size in GB
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(var.tags, {
    Name = "${var.project_name}-${var.env}-secondary-volume"
    })

  }
  user_data = <<-EOF
              #!/bin/bash
              echo "PROJECT_NAME=${var.project_name}" | sudo tee -a /etc/environment
              echo "RELEASE_VERSION=${var.release_version}" | sudo tee -a /etc/environment
              echo "mlangles_mlops_dev_url_https=${var.mlangles_mlops_dev_url_https}" | sudo tee -a /etc/environment
              echo "domain=${var.domain}" | sudo tee -a /etc/environment
              source /etc/environment
              %{ if var.project_name == "mlops" }
              echo "MyServer1 Private IP: ${aws_instance.mlops-terra-dev-gpu[0].private_ip}" > /tmp/mlops-terra-dev-gpu-private-ip.txt
              %{ endif }
              EOF
              
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./Keypairs/${var.project_name}/${var.project_name}-${var.env}-keypair")
    # private_key = file("/home/saicharanthatavarthi/Documents/CA-Git/Automation-Terraform/mlops/dev/mlops-Dev-keypairs/mlops-dev-keypair")
    #private_key = file("/home/sudharani/Downloads/Automation-Terraform/mlops/dev/mlops-Dev-keypairs/mlops-dev-keypair")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "Projects/${var.project_name}/"
    destination = "/home/ubuntu/"
  }

  provisioner "remote-exec" {
    inline = [
    "while IFS='=' read -r key value; do export \"$key=$value\"; done < /etc/environment",
    "echo Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)",
    "echo \"${var.release_version}\" > /home/ubuntu/release_version.txt",
    "sudo chmod 644 /home/ubuntu/release_version.txt",
    "bash -c 'echo \"#TAG001#\"'",
    # ----------------------------------------
    # Set Disk Size Threshold
    # ----------------------------------------
    "SIZE_THRESHOLD_GB=${var.secondarydisksize}",  # Default to 70GB
    "SIZE_THRESHOLD=$((SIZE_THRESHOLD_GB * 1000000000))",

    # ----------------------------------------
    # Set Disk Size Threshold
    # ----------------------------------------
    "DEVICE=$(lsblk -b -o NAME,SIZE | awk -v threshold=\"$SIZE_THRESHOLD\" '$2 >= threshold && $2 <= (threshold + 10000000000) {print \"/dev/\"$1; exit}')",
    "if [ -n \"$DEVICE\" ]; then",
    "  echo \"Device $DEVICE (matching threshold $SIZE_THRESHOLD_GB GB) found, proceeding with formatting and mounting...\"",
    # ----------------------------------------
    # Format and Mount Additional Volume
    # ----------------------------------------
    "  sudo mkfs -t ext4 $DEVICE",
    "  sudo mkdir -p /mnt/user-data",
    "  sudo mount $DEVICE /mnt/user-data",
    # ----------------------------------------
    # Update /etc/fstab for Persistent Mount
    # ----------------------------------------
    "  UUID=$(sudo blkid -s UUID -o value $DEVICE)",
    "  echo \"UUID=$UUID /mnt/user-data ext4 defaults,nofail 0 0\" | sudo tee -a /etc/fstab",
    "  sudo systemctl daemon-reload",
    "  sudo mount -a",
    "  if mountpoint -q /mnt/user-data; then",
    "    echo \"Mount verified successfully at /mnt/user-data\"",
    "  else",
    "    echo \"Mount verification failed!\"",
    "  fi",
    "else",
    "  echo \"No device found matching the size threshold. Skipping disk setup.\"",
    "fi",
    "df -Th",
    # ----------------------------------------
    # Set Ownership and Permissions
    # ----------------------------------------
    "sudo chown ubuntu:ubuntu /mnt/user-data",
    "sudo chmod 777 /mnt/user-data",

    # ----------------------------------------
    # Verify Mount Point
    # ----------------------------------------
    "df -Th",
    "bash -c 'echo \"#TAG002#\"'",
    "sleep 20",
    # ----------------------------------------
    # Execute Pre-requisite Script for CloudOptimax
    # ----------------------------------------
    "if [ \"${var.project_name}\" = \"cloudoptimax\" ]; then echo 'Running cloudoptimax pre-reboot script...'; chmod +x /home/ubuntu/requirements_install.sh; sh /home/ubuntu/requirements_install.sh; fi",

    # ----------------------------------------
    # Execute Pre-requisite Script
    # ----------------------------------------
    "  bash -c 'echo \"#TAG003#\"'",
    "chmod 777 /home/ubuntu/pre-requisites.sh",
     "sh /home/ubuntu/pre-requisites.sh",

    "sleep 300",
     "if echo '${var.project_name}' | grep -q -E '^(mlops|llmops|smartofficenxt)$'; then",
     "  echo 'Running Certbot setup...';",
     "  sudo sed -i \"s/server_name .*/server_name ${var.domain};/\" /etc/nginx/sites-available/default",
     "  sudo apt-get update && sudo apt-get install -y certbot python3-certbot-nginx &&",
     "  sudo certbot --nginx -d ${var.domain} --agree-tos --no-eff-email --email ${var.email} --non-interactive &&",
     #"  sudo sed -i 's|root /var/www/html;|root ${var.nginx_root_path};|g' /etc/nginx/sites-available/default &&",
     "  sudo systemctl reload nginx;",
     "  bash -c 'echo \"#TAG004#\"'",
     "else",
     "  echo 'Skipping Certbot setup for ${var.project_name}';",
     "  bash -c 'echo \"#TAG005#\"'",
     "fi",

    "aws ec2 describe-instances \\",
  "  --filters \"Name=tag:Name,Values=mlops-dev-gpu-pipeline\" \"Name=instance-state-name,Values=running\" \\",
  "  --query \"Reservations[].Instances[].PrivateIpAddress\" \\",
  "  --output text > /tmp/mlops-terra-dev-gpu-private-ip.txt",

    # ----------------------------------------
    # Execute Ansible Scripts
    # ----------------------------------------
     "if echo '${var.project_name}' | grep -q -E '^(mlops|llmops)$'; then ansible-playbook -i /home/ubuntu/inventory.ini deploy.yaml; bash -c 'echo \"#TAG006#\"'; fi",
    
    # ---------------------------------------------------------
    # Execute bash script to create License for login Platform.
    # ---------------------------------------------------------
    "if [ \"${var.project_name}\" = \"mlops\" ]; then chmod +x /home/ubuntu/License-Scripts/license_creation_script.sh; sh /home/ubuntu/License-Scripts/license_creation_script.sh; fi",
    "sleep 30",
    "bash -c 'echo \"#OPS100#\"'",

    ]
  }

}