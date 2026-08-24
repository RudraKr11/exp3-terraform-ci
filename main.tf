terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "ci_demo" {
  bucket_prefix = "exp3-terraform-ci-"

  tags = {
    Name       = "exp3-ci-demo"
    ManagedBy  = "Terraform"
    Experiment = "03"
  }
}