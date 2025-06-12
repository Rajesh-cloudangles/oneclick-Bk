ami = "ami-0f9de6e2d2f067fca" #24.04
instance_type = "t3a.medium"
project_name = "smartofficenxt"
tags = {
    Environment = "qa"
    Project     = "smartofficenxt"
}
primarydisksize = "10"
secondarydisksize = "8"
#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0kS8LSD3ZIssnG+wo3pe+G1vDRqJrh40ZS5La+J+dDNW9crxzTpdEzR6lHBPpP24sUBD8Zc0BTNM5Hu3Gp9amefkvgS+L62RWbcb8+7KQV7xZVztsbFno7xfNbO+XfogjGVu4de8acCPHYLM/GLVgKO++eh3S2ACGIUZIoLGF689dIma6vjVnqnDYjJwFZKMyp3vr5yo2HGELdoadosbsvdCtSMSuaEZOPfooxnuHLvGmlpwUM8MxxkmeL1G4yfHZzdKXyihaDYyugISedxrPobSHWlx/96rcZoHryZCeFzhDT0SccZcac4pnMEXqqJLRU+eMDGVceRMgjWZ9iZYH"
cidr_block = "28.0.0.0/16"
subnet_cidr = "28.0.0.0/24"
ingress_rules = [
  { port = 22,   cidr_block = "203.109.95.162/32" },
  { port = 80,   cidr_block = "0.0.0.0/0" },
  { port = 443,   cidr_block = "0.0.0.0/0" }
]
env = "qa"

release_version = "Release-v1.0"
UBUNTU_PASSWORD = "1Lk73964RZUBnZR6BNz7T74icPFfmuLeNb"

###Below are variables not declared in cloudoptimax project####
email = "cloud.supportteam@cloudangles.com"
#nginx_root_path = "/mnt/user-data/mlops-frontend/build"
mlangles_mlops_dev_url_https = "https://auto.cloudangles.com"
domain = "qa.smartangles.site"