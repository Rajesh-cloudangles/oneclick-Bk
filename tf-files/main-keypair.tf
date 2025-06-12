resource "aws_key_pair" "ec2keypair" {
  provider = aws.n-virginia

  key_name   = "${var.project_name}-${var.env}-keypair" 
  public_key = var.public_key
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-keypair"
})
}