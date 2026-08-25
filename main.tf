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

# Use the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Use an existing subnet in the default VPC
data "aws_subnet" "selected" {
  id = var.subnet_id
}

# Security group for the CI/CD demonstration
resource "aws_security_group" "web" {
  name        = "exp3-ci-web-sg"
  description = "Security group managed by Terraform for Experiment 3"
  vpc_id      = data.aws_vpc.default.id

  # INTENTIONALLY INSECURE FOR THE SECURITY-SCAN DEMONSTRATION
  ingress {
    description = "SSH - intentionally public for tfsec demonstration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "exp3-ci-web-sg"
    ManagedBy  = "Terraform"
    Experiment = "03"
  }
}

# Amazon Linux 2023 ARM64 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t4g.micro"
  subnet_id     = data.aws_subnet.selected.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  tags = {
    Name       = "exp3-ci-web"
    ManagedBy  = "Terraform"
    Experiment = "03"
  }
}