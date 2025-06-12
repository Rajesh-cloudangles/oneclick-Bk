resource "aws_security_group" "mlops-terra-dev-gpu-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "mlops-terra-dev-gpu-sg"
  count       = var.project_name == "mlops" ? 1 : 0

  dynamic "ingress" {
    for_each = var.ingress_gpu_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr_block]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-gpu-SG"
})
}
