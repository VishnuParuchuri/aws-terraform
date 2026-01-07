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

# ---------------------------
# S3 Bucket for Terraform State
# ---------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = {
    Name      = "terraform-state-bucket"
    ManagedBy = "Terraform"
  }
}

# Enable versioning (VERY IMPORTANT)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------
# DynamoDB Table for Locking
# ---------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "terraform-lock-table"
    ManagedBy = "Terraform"
  }
}
