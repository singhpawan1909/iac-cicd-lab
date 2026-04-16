terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "student_suffix" {
  description = "Unique suffix for your resources"
  type        = string
  default     = "mummyji"
}

# Create the S3 bucket
resource "aws_s3_bucket" "lab" {
  bucket = "sigmoid-iac123-${var.student_suffix}"

  tags = {
    Name    = "sigmoid-iac-${var.student_suffix}"
    Owner   = var.student_suffix
    Lab     = "IaC-S3-CICD"
    Cleanup = "aws-cli-destroy"
  }
}

# Upload a small file into the bucket
resource "aws_s3_object" "hello" {
  bucket  = aws_s3_bucket.lab.id
  key     = "1.txt"
  content = "Hello from Terraform pipeline - deployed by ${var.student_suffix}"
}

output "bucket_name" {
  value = aws_s3_bucket.lab.id
}

output "bucket_arn" {
  value = aws_s3_bucket.lab.arn
}

output "object_key" {
  value = aws_s3_object.hello.key
}
