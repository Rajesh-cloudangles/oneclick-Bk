ami = "ami-0f9de6e2d2f067fca" #22.04
instance_type = "t3a.xlarge"
project_name = "mlops"
tags = {
    Environment = "dev"
    Project     = "mlops"
}
mlangles_mlops_dev_url_https = "https://automation.mlangles.ai"
domain = "dummy.cloudoptimax.com"
primarydisksize = "15"
secondarydisksize = "50"

#keypair.tf
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7dvbSEiCwAuObsVo2fNtkXSQsH4zCgRRsZno80xsiUrmZ/efRkbVQhgZmaexATKwZcA9xVNnqljUk2h8t/JlRCsmNXWzxEmZWtKXKfnfNjSBse20Ihd2Wt1sLf2LZpR3yx6XBtVcR05sfLIalVPWVUxnhE7LSnZx+NUIryuEZUiKm2hLdUIzCtXTO/UVWKZVEl1/yj6aHrNbI+xLVVxGLlg1v1O54F+dgZGs4ni1QFFSQYcEvHCeQDk7/TpDjhUZ9HQFrMzXMKSTvHBnf7jJcCteK5Di5TRtT4yBltV+eG+fjdcsCUzgfW+NmRZ+4stLQSoBPV6NF/g0C3MA2EnJX"
cidr_block = "21.0.0.0/16"
subnet_cidr = "21.0.0.0/24"
ingress_rules = [
  { port = 8080, cidr_block = "1.2.3.4/32" },
  { port = 8080, cidr_block = "5.6.7.8/32" },
  { port = 22,   cidr_block = "0.0.0.0/0" },
  { port = 80,   cidr_block = "0.0.0.0/0" },
  { port = 443,   cidr_block = "0.0.0.0/0" }
]
env = "dev"
mlops_gpuec2_instance_type = "g4dn.xlarge"
mlops_gpu_rootvolume_size = "50"
mlops_gpu_secondary_volume_size = "70"
gpuami = "ami-00a4dc78b2661d64d"
ingress_gpu_rules = [
  { port = 8080, cidr_block = "1.2.3.4/32" },
  { port = 8080, cidr_block = "5.6.7.8/32" },
  { port = 22,   cidr_block = "0.0.0.0/0" },
  { port = 80,   cidr_block = "0.0.0.0/0" },
  { port = 443,   cidr_block = "0.0.0.0/0" }
]
gpupublic_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZPg7n3VE5oearVGydY0AQquv4bavLDcBoODDb0oLHnMLbkZ0ZQGz0AsdoG88FowM+FIhfJzyDK+665LGbfJbCJEFBr5GuNeXv1igP0PVmsv4mOMoOoP8T1Jd0Igmuj8PtYBZf61FRwJ62HgdbRanJNwNVHmahRBiFLr4paxrv8FWIlhjK9mtkkv9coqHdRz7cmhjcZ6G3MS4SvxBnXgO5VPG7wY+8nt661t6JuxC9eR1Tm39I346UUD2Ap0o6PAEXhDaC6mGT55d01r5NC8N5Cih/Rd47PLstIz3785GvlTuhD7a4pyo8HBZ9xomOp8LPL1aJY28TEU0drVnh6XBz"

release_version = "Release-v1.0"

email = "cloud.supportteam@cloudangles.com"

#nginx_root_path = "/mnt/user-data/mlops-frontend/build"

UBUNTU_PASSWORD = "1Lk73964RZUBnZR6BNz7T74icPFfmuLeNb"