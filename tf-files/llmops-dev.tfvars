ami = "ami-0f9de6e2d2f067fca" #22.04
instance_type = "t3a.xlarge"
project_name = "llmops"
tags = {
    Environment = "dev"
    Project     = "llmops"
}
mlangles_mlops_dev_url_https = "https://automation.mlangles.ai"
domain = "automation.mlangles.ai"
primarydisksize = "25"
secondarydisksize = "50"

# Key pulled
#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJn9LQVbOt2mbY/EnCJIshGaI6fwkRdxHZR/B8C1rfXkyTeBxlAjMbfSvlPmLmUFE05MGWSl2bNHkemPDCplnHtHMYc7/HXSgvoLZjBhiWFZ5IxVgiPKmIZD/MpelJejIqlpX7LlTyr6lSXC9b2dm+j5oMqDSy7IHqZ1h8q/w2nZlK+gQ4PwuLdnA5lTvbFvemP+PkVo5gWthzrwQinseOAjv7eOb5bJD0NlzMFRlOB5AzE28gRw5OVrFhYP2Aw9aQBVWw7zdZ6n2dQiG/tY0mrtRayJB3vaIKb7E+v76EWoOSctkbVkBTrJPaMj/OsCwEMLIk6BWhzyKE1oeD/njt"
cidr_block = "26.0.0.0/16"
subnet_cidr = "26.0.0.0/24"
ingress_rules = [
  { port = 8080, cidr_block = "1.2.3.4/32" },
  { port = 8080, cidr_block = "5.6.7.8/32" },
  { port = 22,   cidr_block = "0.0.0.0/0" }
]
env = "dev"
