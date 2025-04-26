module "web_application" {
  source      = "../../patterns/web-application"
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  environment = var.environment
  project_name = "${var.company_name}-ecommerce"
  ami_id      = var.ami_id
  instance_type = "t3.medium"
  min_size    = 2
  max_size    = 10
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.company_name}-cache-subnet"
  subnet_ids = module.web_application.private_subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.company_name}-redis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.company_name}-db-subnet"
  subnet_ids = module.web_application.private_subnet_ids
}

resource "aws_db_instance" "products" {
  allocated_storage    = 20
  db_name              = "products"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.small"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
  multi_az             = true
}

resource "aws_s3_bucket" "product_images" {
  bucket = "${var.company_name}-product-images"
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.product_images.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.product_images.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.product_images.bucket}"

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
}
