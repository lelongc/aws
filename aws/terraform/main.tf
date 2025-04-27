provider "aws" {
  region = var.region
  profile = var.environment
}

# Define variables
variable "region" {
  description = "AWS region to deploy resources"
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  default     = "my-app"
}

# VPC and networking
module "vpc" {
  source = "./modules/vpc"
  
  environment = var.environment
  app_name    = var.app_name
  cidr_block  = "10.0.0.0/16"
  azs         = ["ap-southeast-1a", "ap-southeast-1b"]
}

# ECS Cluster
module "ecs" {
  source = "./modules/ecs"
  
  environment = var.environment
  app_name    = var.app_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
}

# RDS Database
module "rds" {
  source = "./modules/rds"
  
  environment         = var.environment
  app_name            = var.app_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  db_name             = "${var.app_name}_db"
  db_username         = "admin"
  db_password         = var.db_password
  instance_class      = "db.t3.small"
  allocated_storage   = 20
}

# S3 Bucket for assets
resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.environment}-${var.app_name}-assets"
  
  tags = {
    Name        = "${var.environment}-${var.app_name}-assets"
    Environment = var.environment
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "app_assets_policy" {
  bucket = aws_s3_bucket.app_assets.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { 
          AWS = module.ecs.task_role_arn
        }
        Action    = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource  = [
          "${aws_s3_bucket.app_assets.arn}",
          "${aws_s3_bucket.app_assets.arn}/*"
        ]
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "app_distribution" {
  origin {
    domain_name = aws_s3_bucket.app_assets.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.app_assets.bucket}"
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.app_assets.bucket}"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  tags = {
    Name        = "${var.environment}-${var.app_name}-cf"
    Environment = var.environment
  }
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.app_distribution.domain_name
}

output "s3_bucket" {
  value = aws_s3_bucket.app_assets.bucket
}
