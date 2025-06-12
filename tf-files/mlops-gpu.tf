 #Create an GPU EC2 instance
resource "aws_instance" "mlops-terra-dev-gpu" {
  count         = var.project_name == "mlops" ? 1 : 0
  ami           = var.gpuami  # nivicuda AMI
  instance_type = var.mlops_gpuec2_instance_type
  key_name      = "mlops-terra-dev-gpu-keypair"   # Ensure this key exists in AWS Mlops
  subnet_id      = aws_subnet.publicsubnet.id
  vpc_security_group_ids = [aws_security_group.mlops-terra-dev-gpu-sg[0].id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  
  root_block_device {
    volume_size           = var.mlops_gpu_rootvolume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(var.tags, {
    Name = "${var.project_name}-${var.env}-gpu-pipeline-root-ebs"
    })

  }
  # Attach a secondary EBS volume (150GB in this case)
  ebs_block_device {
    device_name           = "/dev/xvdb"  # Secondary volume device name
    volume_size           = var.mlops_gpu_secondary_volume_size          # Size in GB
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(var.tags, {
    Name = "${var.project_name}-${var.env}-gpu-pipeline-sec-ebs"
    })
  }
  user_data = <<-EOF
              #!/bin/bash
              echo "mlangles_mlops_dev_url_https=${var.mlangles_mlops_dev_url_https}" >> /etc/environment
              echo "domain=${var.domain}" >> /etc/environment
              source /etc/environment
              EOF

  # SSH Connection Configuration
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./Keypairs/mlops/mlops-dev-gpu-keypair")
    # private_key = file("/home/saicharanthatavarthi/Documents/CA-Git/Automation-Terraform/mlops/dev/mlops-Dev-keypairs/mlops-dev-gpu-keypair")
    #private_key = file("/home/sudharani/Downloads/Automation-Terraform/mlops/dev/mlops-Dev-keypairs/mlops-dev-gpu-keypair")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "Projects/mlops/gpufolder/"
    destination = "/home/ubuntu/"
  }

  # Install MySQL and Restore Database
    provisioner "remote-exec" {
      inline = [
      "echo \"${var.release_version}\" > /home/ubuntu/release_version.txt",
      "bash -c 'echo \"#TAG104#\"'",
      # ----------------------------------------
      # Set Disk Size Threshold
      # ----------------------------------------
      "SIZE_THRESHOLD_GB=${var.mlops_gpu_secondary_volume_size}",  # Default to 70GB
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
      "bash -c 'echo \"#OPS301#\"'",
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

      "bash -c 'echo \"#OPS302#\"'",
      # ----------------------------------------
      # Set Ownership and Permissions
      # ----------------------------------------
      "sudo chown ubuntu:ubuntu /mnt/user-data",
      "sudo chmod 777 /mnt/user-data",

      # ----------------------------------------
      # Verify Mount Point
      # ----------------------------------------
      "df -Th",
      "bash -c 'echo \"#OPS304#\"'",
      # ----------------------------------------
      # Execute Pre-requisite Script
      # ----------------------------------------
      "chmod 777 /home/ubuntu/gpu-requirements",
      "sh /home/ubuntu/gpu-requirements.sh",

      # ----------------------------------------
      # Execute Ansible Scripts
      # ----------------------------------------
      "ansible-playbook -i /home/ubuntu/inventory.ini gpudeploy.yaml",
      "sleep 50",
      "bash -c 'echo \"#TAG109#\"'"
      ]
    }

  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-gpu-pipeline"
  })
}
resource "null_resource" "mlops_gpu_dependency" {
  count = var.project_name == "mlops" ? 1 : 0

  depends_on = [
    aws_instance.mlops-terra-dev-gpu
  ]
}

output "gpupublic_ip" {
  value = length(aws_instance.mlops-terra-dev-gpu) > 0 ? aws_instance.mlops-terra-dev-gpu[0].public_ip : ""
}

output "myserver1_private_ip" {
  value = length(aws_instance.mlops-terra-dev-gpu) > 0 ? aws_instance.mlops-terra-dev-gpu[0].private_ip : ""
}
