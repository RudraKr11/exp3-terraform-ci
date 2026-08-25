variable "aws_region" {
  description = "AWS region for the CI/CD experiment"
  type        = string
  default     = "ap-south-1"
}

variable "subnet_id" {
  description = "Existing subnet used by the CI/CD demonstration"
  type        = string
  default     = "subnet-0f6c4b8e1c2a9627a"
}

variable "ami_id" {
  description = "Amazon Linux 2023 ARM64 AMI"
  type        = string
  default     = "ami-0f078ecdf4d6d94de"
}