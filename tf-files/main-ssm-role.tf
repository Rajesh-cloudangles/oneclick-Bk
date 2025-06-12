resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-${var.env}-ssm-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
  tags = merge(var.tags, {
  Name = "${var.project_name}-${var.env}-IAM-Role"
})

}

resource "aws_iam_policy" "kms_secrets_access_policy" {
  name        = "${var.project_name}-${var.env}-kms-secrets-policy"
  description = "Policy to allow KMS decrypt/encrypt for secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "arn:aws:kms:us-east-1:807923266708:key/e91188bc-791d-4909-bdeb-a3fcecf393a9"
      }
    ]
  })
}
resource "aws_iam_policy" "ec2_describe_policy" {
  name        = "${var.project_name}-${var.env}-ec2-describe-policy"
  description = "Policy to allow describing EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "kms_secrets_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.kms_secrets_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "ec2_describe_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ec2_describe_policy.arn
}
# Attach Secrets Manager Full Access Policy
resource "aws_iam_role_policy_attachment" "mlops-terra-dev-secrets-attach" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "crossaccount-inc-github-artifacts-ca" {
  policy_arn = "arn:aws:iam::807923266708:policy/crossaccount-inc-github-artifacts-ca"
  role       = aws_iam_role.ssm_role.name
}

# Attach ECR Full Access Policy
resource "aws_iam_role_policy_attachment" "mlops_ecr_full_access_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project_name}-${var.env}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}
