resource "aws_key_pair" "gpuec2keypair" {
  provider = aws.n-virginia
  count      = var.project_name == "mlops" ? 1 : 0
  key_name   = "mlops-terra-dev-gpu-keypair"
  public_key = var.gpupublic_key
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-gpuec2keypair"
})
}