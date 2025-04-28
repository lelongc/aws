provider "aws" {
  region = var.region
}

# Terraform state bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-${var.environment}-terraform-state"

  tags = {
    Name        = "${var.project}-${var.environment}-terraform-state"
    Environment = var.environment
    Terraform   = "true"
    Project     = var.project
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Logging bucket
resource "aws_s3_bucket" "logging" {
  bucket = "${var.project}-${var.environment}-logging"

  tags = {
    Name        = "${var.project}-${var.environment}-logging"
    Environment = var.environment
    Terraform   = "true"
    Project     = var.project
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging_lifecycle" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = var.log_retention_days
    }
  }
}

resource "aws_s3_bucket_versioning" "logging_versioning" {
  bucket = aws_s3_bucket.logging.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Artifacts bucket
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.environment}-artifacts"

  tags = {
    Name        = "${var.project}-${var.environment}-artifacts"
    Environment = var.environment
    Terraform   = "true"
    Project     = var.project
  }
}

resource "aws_s3_bucket_versioning" "artifacts_versioning" {
  bucket = aws_s3_bucket.artifacts.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts_encryption" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
