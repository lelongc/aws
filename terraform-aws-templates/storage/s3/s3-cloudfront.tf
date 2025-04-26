provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

locals {
  name        = var.name
  environment = var.environment
  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# S3 bucket for the website
resource "aws_s3_bucket" "this" {
  bucket = "${local.name}-${local.environment}"
  
  tags = local.tags
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ACL
resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

# Bucket public access block
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# SSE encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

# Bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-to-standard-ia"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = var.objects_expiration_days
    }
  }

  # Add rule for non-current versions if versioning is enabled
  dynamic "rule" {
    for_each = var.enable_versioning ? [1] : []
    content {
      id     = "delete-old-versions"
      status = "Enabled"

      filter {
        prefix = ""
      }

      noncurrent_version_expiration {
        noncurrent_days = 90
      }
    }
  }
}

# Bucket policy for CloudFront access
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.this]
}

# CloudFront Origin Access Identity (legacy)
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${local.name}-${local.environment}"
}

# CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.name}-${local.environment}-oac"
  description                       = "OAC for ${local.name}-${local.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ACM Certificate for CloudFront
resource "aws_acm_certificate" "this" {
  count = length(var.domain_names) > 0 ? 1 : 0
  
  provider = aws.us-east-1 # CloudFront requires certificates in us-east-1
  
  domain_name               = var.domain_names[0]
  subject_alternative_names = length(var.domain_names) > 1 ? slice(var.domain_names, 1, length(var.domain_names)) : []
  validation_method         = "DNS"
  
  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.name} ${local.environment} distribution"
  default_root_object = var.default_root_object
  price_class         = var.price_class
  
  # Use aliases if domain names are provided
  aliases = length(var.domain_names) > 0 ? var.domain_names : []

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = "s3-${aws_s3_bucket.this.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${aws_s3_bucket.this.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  # Cache behavior for specific patterns
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = "s3-${aws_s3_bucket.this.id}"

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
        cookies {
          forward = ordered_cache_behavior.value.forward_cookies
        }
      }

      compress               = true
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
    }
  }

  # Use custom SSL certificate if domain names are provided
  dynamic "viewer_certificate" {
    for_each = length(var.domain_names) > 0 ? [1] : []
    content {
      acm_certificate_arn      = aws_acm_certificate.this[0].arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  # Use CloudFront default certificate if no domain names are provided
  dynamic "viewer_certificate" {
    for_each = length(var.domain_names) == 0 ? [1] : []
    content {
      cloudfront_default_certificate = true
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # Web Application Firewall (WAF) integration
  web_acl_id = var.web_acl_id

  # Logging configuration
  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      include_cookies = false
      bucket          = var.logging_bucket
      prefix          = "${local.name}-${local.environment}/"
    }
  }

  tags = local.tags
}
