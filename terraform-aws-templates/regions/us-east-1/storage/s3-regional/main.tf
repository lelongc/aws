provider "aws" {
  region = var.region
}

# Create S3 bucket
resource "aws_s3_bucket" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  
  bucket = "${var.project}-${var.environment}-${each.value.name}"
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    each.value.tags
  )
}

# Block public access for all buckets
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  
  bucket                  = aws_s3_bucket.this[each.key].id
  block_public_acls       = each.value.block_public_access
  block_public_policy     = each.value.block_public_access
  ignore_public_acls      = each.value.block_public_access
  restrict_public_buckets = each.value.block_public_access
}

# Enable versioning
resource "aws_s3_bucket_versioning" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket if bucket.versioning_enabled }
  
  bucket = aws_s3_bucket.this[each.key].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  
  bucket = aws_s3_bucket.this[each.key].id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = each.value.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = each.value.kms_key_id
    }
    bucket_key_enabled = each.value.bucket_key_enabled
  }
}

# Configure lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket if length(bucket.lifecycle_rules) > 0 }
  
  bucket = aws_s3_bucket.this[each.key].id
  
  dynamic "rule" {
    for_each = each.value.lifecycle_rules
    
    content {
      id     = rule.value.id
      status = rule.value.status
      
      dynamic "transition" {
        for_each = rule.value.transitions
        
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
      
      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        
        content {
          days = expiration.value.days
        }
      }
      
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        
        content {
          noncurrent_days = noncurrent_version_transition.value.days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
      
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        
        content {
          noncurrent_days = noncurrent_version_expiration.value.days
        }
      }
    }
  }
  
  depends_on = [aws_s3_bucket_versioning.this]
}

# Configure CORS if specified
resource "aws_s3_bucket_cors_configuration" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket if bucket.cors_rules != null && length(bucket.cors_rules) > 0 }
  
  bucket = aws_s3_bucket.this[each.key].id
  
  dynamic "cors_rule" {
    for_each = each.value.cors_rules
    
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# Configure bucket policy if specified
resource "aws_s3_bucket_policy" "this" {
  for_each = { for bucket in var.buckets : bucket.name => bucket if bucket.policy != null }
  
  bucket = aws_s3_bucket.this[each.key].id
  policy = each.value.policy
}
