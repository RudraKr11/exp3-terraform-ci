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

  ingress {
    description = "SSH from selected subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.32.0/20"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
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

  # Require IMDSv2 tokens
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Encrypt the root EBS volume
  root_block_device {
    encrypted = true
  }

  tags = {
    Name       = "exp3-ci-web"
    ManagedBy  = "Terraform"
    Experiment = "03"
  }
}