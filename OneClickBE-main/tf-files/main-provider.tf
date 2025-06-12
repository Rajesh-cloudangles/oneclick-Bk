terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
  # backend "s3" {
  #   bucket = "automation-mlops-s3-terraformbackend"
  #   key    = "terraform-state-backup/state-backup-file"
  #   region = "us-east-1"
  # }
}
provider "aws" {
  alias  = "n-virginia"
  region = "us-east-1"
}
