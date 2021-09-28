data "aws_caller_identity" "current" {}

locals {
  default_bucket_name         = "terraform-state-storage-${var.state_name}"
  default_dynamodb_table_name = "terraform-state-lock-${var.state_name}"
}

resource "aws_s3_bucket" "terraform-state-storage" {
  bucket = var.bucket_name == "" ? local.default_bucket_name : var.bucket_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id                                     = "AutoAbortFailedMultipartUpload"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 10
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = var.bucket_name == "" ? local.default_bucket_name : var.bucket_name
    Environment = var.environment
  }

}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.terraform-state-storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = var.dynamodb_table_name == "" ? local.default_dynamodb_table_name : var.dynamodb_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.dynamodb_table_name == "" ? local.default_dynamodb_table_name : var.dynamodb_table_name
    Environment = var.environment
  }

}