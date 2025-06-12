##-------------##
    ##tags##
##-------------##
variable "tags" {
  description = "give instance id"
  type        = map(string)
}

##-------------##
    ##Projectname##
##-------------##

variable "project_name" {
  description = "Project to trigger scripts for"
  type        = string
}

variable "env" {
  description = "Project to trigger scripts for"
  type        = string
}

##-------------##
   ##ec2.tf##
##-------------##

variable "ami" {
  description = "OS AMI"
  type        = string
}

variable "instance_type" {
  description = "give instance id"
  type        = string
}

variable "mlangles_mlops_dev_url_https" {
  description = "give instance id"
  type        = string
}

variable "domain" {
  description = "give instance id"
  type        = string
}

variable "primarydisksize" {
  description = "give instance id"
  type        = string
}


variable "secondarydisksize" {
  description = "give instance id"
  type        = string
}

##-------------##
   ##keypair.tf##
##-------------##

variable "public_key" {
  description = "give instance id"
  type        = string
}


##-------------##
   ##sg.tf##
##-------------##

variable "ingress_rules" {
  description = "List of ingress rules with port and CIDR"
  type = list(object({
    port       = number
    cidr_block = string
  }))
}


##-------------##
   ##vpc.tf##
##-------------##

variable "cidr_block" {
  description = "give instance id"
  type        = string
}
variable "subnet_cidr" {
  description = "give instance id"
  type        = string
}


variable "allowed_ports" {
  description = "List of individual TCP ports to allow"
  type        = list(number)
  default     = []
}

##-------------##
   ##mlops-gpu.tf##
##-------------##

variable "mlops_gpuec2_instance_type" {
  description = "GPU instance type"
  type        = string
  default     = ""
  validation {
    condition     = var.project_name != "mlops" || (length(var.mlops_gpuec2_instance_type) > 0)
    error_message = "mlops_gpuec2_instance_type must be set when project_name is 'mlops'."
  }
}


variable "mlops_gpu_rootvolume_size" {
  description = "Root volume size for GPU EC2"
  type        = string
  default     = ""
  validation {
    condition     = var.project_name != "mlops" || (length(var.mlops_gpu_rootvolume_size) > 0)
    error_message = "mlops_gpu_rootvolume_size must be set when project_name is 'mlops'."
  }
}
variable "mlops_gpu_secondary_volume_size" {
  description = "Secondary volume size for GPU EC2"
  type        = string
  default     = ""
  validation {
    condition     = var.project_name != "mlops" || (length(var.mlops_gpu_secondary_volume_size) > 0)
    error_message = "mlops_gpu_secondary_volume_size must be set when project_name is 'mlops'."
  }
}

variable "gpuami" {
  description = "GPU AMI ID"
  type        = string
  default     = ""
  validation {
    condition     = var.project_name != "mlops" || (length(var.gpuami) > 0)
    error_message = "gpuami must be set when project_name is 'mlops'."
  }
}

##-------------##
   ##gpu-sg.tf##
##-------------##

variable "ingress_gpu_rules" {
  description = "Ingress rules for GPU instance"
  type = list(object({
    port       = number
    cidr_block = string
  }))
  default = []
  validation {
    condition     = var.project_name != "mlops" || length(var.ingress_gpu_rules) > 0
    error_message = "ingress_gpu_rules must be set when project_name is 'mlops'."
  }
}

variable "gpupublic_key" {
  description = "SSH public key for GPU EC2"
  type        = string
  default     = ""
  validation {
    condition     = var.project_name != "mlops" || (length(var.gpupublic_key) > 0)
    error_message = "gpupublic_key must be set when project_name is 'mlops'."
  }
}

##-------------##
##Release Version##
##-------------##
variable "release_version" {
  description = "Version of the release artifact to pull from S3"
  type        = string
}

##-------------##
    ##Email##
##-------------##
variable "email" {
  description = "Email to get notifications for SSL renewal"
  type        = string
}

#variable "nginx_root_path" {
#  description = "Root path for Nginx site"
#  type        = string
#}

##-------------------#
 ##UBUNTU_PASSWORD##
##------------------##
variable "UBUNTU_PASSWORD" {
  type      = string
  sensitive = true
}
