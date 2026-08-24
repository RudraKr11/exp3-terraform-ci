output "bucket_name" {
  description = "Name of the S3 bucket created by Terraform"
  value       = aws_s3_bucket.ci_demo.bucket
}