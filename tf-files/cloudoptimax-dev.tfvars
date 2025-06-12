ami = "ami-0f9de6e2d2f067fca" #24.04
instance_type = "c6a.2xlarge"
project_name = "cloudoptimax"
tags = {
    Environment = "dev"
    Project     = "cloudoptimax"
}
primarydisksize = "100"
secondarydisksize = "8"
#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+6DXWmN/yuObLN17tFN/QANotET/lxzO/3V7mqaK1siyJBw18FBWlZAWp7LPGZoLJorM8gNqIvG3MHTiI2J+5aSZYP2THpqLXiZVZ4yk2QU5E32TPkJQL+7rA2Ht4pdKXGfriSg1wantqjEoJSPMZQL6Jq+oBY9a71O1dnxJ+DCFJc3KWDqXcEiSvgtK6BxAU3TTiwaK3A9ri4VKCTzhICm8uTa7zxx8+jqGcfCVeZSGJYrgPP3tGY3TjE9aTszWHhiiIBNBdpHmDEjII2vvO+4QJuiOtgefmNQeBo+IHVpgZjOc4OJ/b7aAzKfLP4bDJAsQvREb1iIgB8CFpzYgl"
cidr_block = "18.0.0.0/16"
subnet_cidr = "18.0.0.0/24"
ingress_rules = [
  { port = 22,   cidr_block = "0.0.0.0/0" },
  { port = 80,   cidr_block = "0.0.0.0/0" },
  { port = 443,   cidr_block = "0.0.0.0/0" }
]
env = "dev"

release_version = "Release-v1.0"
UBUNTU_PASSWORD = "1Lk73964RZUBnZR6BNz7T74icPFfmuLeNb"

###Below are variables not declared in cloudoptimax project####
email = "cloud.supportteam@cloudangles.com"
#nginx_root_path = "/mnt/user-data/mlops-frontend/build"
mlangles_mlops_dev_url_https = "https://auto.cloudangles.com"
domain = "auto.cloudangles.com"