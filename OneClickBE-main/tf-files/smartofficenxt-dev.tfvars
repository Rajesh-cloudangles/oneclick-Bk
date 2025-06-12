ami = "ami-0f9de6e2d2f067fca" #24.04
instance_type = "t3a.medium"
project_name = "smartofficenxt"
tags = {
    Environment = "dev"
    Project     = "smartofficenxt"
}
primarydisksize = "10"
secondarydisksize = "8"
#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyaeeIlUs8QMA6ZyI2PMZuXv8JDs1z8vjsjKDsETXIEIOqSLH+MBh6C8AO1kxPGlni76dX1KZOYjVpDBpTfz1vInk3A0MPA+2cK728xljd3mCOkrxeBRcp7PONwT0SRLrN2axEukdRqeNRj3HmDQYXvv/yrDP5ftxAbZH1AAT38nxb8l6VYK8kn2GQda9JZemy666ce/nUd835tJ1gIakR+A/Ve2XlhC2/mjHydeUaw6ERGYac+utPAeDrMzNhizbMxM5UaYF+5I5ZAXC7KxLoVPV5CEzH4WFTd0N0Lef8S44Lin+GpAGn7712yN+0hSk8p+lbgSsj+dOf2TkUU41P"
cidr_block = "28.0.0.0/16"
subnet_cidr = "28.0.0.0/24"
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
domain = "dev.smartangles.site"