ami = "ami-0f9de6e2d2f067fca" #24.04
instance_type = "t3a.large"
project_name = "smartofficenxt"
tags = {
    Environment = "demo"
    Project     = "smartofficenxt"
}
primarydisksize = "10"
secondarydisksize = "8"
#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDtyTIUVDKkq0Ry61v0JAlxB1irKniVj0pyQvwkmA/p4jh3ADdzPfUoQqnbEX7M6CjOHNi343nBfPl4I+ICRDzZKZmG7OTIIrLrEUCJ60geVt7kAiJD4a0+Xh15+/F/E6qlI8XjwpUfSYO3kTdGiKRV1U4/5KC5NGkILyf/9P5YWx+PPjZ8T5CLsDPBHXHCwLiWoj/O1IsbyODrVTYs1Y13PUl5wlLydNEQ5+O5TuSw5P6t6+SeGY+O3f61z+FVXh9NyD3DTw0nupx5JrZhvt8pXO+tQce054ei84Lj5iGaJASDrGvtjX2egx+0ImIt7QIuo5MPVS6g6G6lnJhvAKV5"
cidr_block = "28.0.0.0/16"
subnet_cidr = "28.0.0.0/24"
ingress_rules = [
  { port = 22,   cidr_block = "0.0.0.0/0" },
  { port = 80,   cidr_block = "0.0.0.0/0" },
  { port = 443,   cidr_block = "0.0.0.0/0" }
]
env = "demo"

release_version = "Release-v1.0"
UBUNTU_PASSWORD = "1Lk73964RZUBnZR6BNz7T74icPFfmuLeNb"

###Below are variables not declared in cloudoptimax project####
email = "cloud.supportteam@cloudangles.com"
#nginx_root_path = "/mnt/user-data/mlops-frontend/build"
mlangles_mlops_dev_url_https = "https://auto.cloudangles.com"
domain = "demo.smartangles.site"