# VPC: Virtual Private Cloud setup
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-vpc"
})

}

# Default Route Table: Assign default route table for the VPC
resource "aws_default_route_table" "defaultroutetable" {

  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-RT"
})

}

# Default Network ACL: Configure default network access control list
resource "aws_default_network_acl" "defaultnacl" {

  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    icmp_code  = 0
    icmp_type  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    icmp_code  = 0
    icmp_type  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }

   subnet_ids = [
    "${aws_subnet.publicsubnet.id}"
  ]
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-NACL"
})

}

# Public Subnet: Create public subnet within the VPC
resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-subnet"
})

}

# Internet Gateway: Enable internet access for the VPC
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-IG"
})

}

# Route for Internet Gateway: Define route to send all traffic to the internet gateway
resource "aws_route" "defaultroutetableassociation" {

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internetgateway.id
  route_table_id         = aws_default_route_table.defaultroutetable.id
}

# Route Table Association for Public Subnet: Associate the public subnet with the default route table
resource "aws_route_table_association" "publicsubnetassociation" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_default_route_table.defaultroutetable.id
}

