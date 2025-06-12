# resource "null_resource" "project_setup" {
#   triggers = {
#     project = var.project_name
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       echo "Running setup for project: ${var.project_name}"
#       bash ./Projects/${var.project_name}/pre-requisites.sh
#       ansible-playbook ./Projects/${var.project_name}/deploy.yaml
#     EOT
#   }
# }
