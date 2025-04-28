provider "aws" {
  region = var.region
}

# Create the root hosted zone if it doesn't exist
resource "aws_route53_zone" "main" {
  count = var.create_root_zone ? 1 : 0
  
  name = var.domain_name
  
  tags = {
    Name        = var.domain_name
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Create subdomain hosted zone for the environment
resource "aws_route53_zone" "environment" {
  count = var.create_env_zone ? 1 : 0
  
  name = "${var.environment}.${var.domain_name}"
  
  tags = {
    Name        = "${var.environment}.${var.domain_name}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Create NS records in the root zone for the environment subdomain
resource "aws_route53_record" "environment_ns" {
  count = var.create_root_zone && var.create_env_zone ? 1 : 0
  
  zone_id = aws_route53_zone.main[0].zone_id
  name    = "${var.environment}.${var.domain_name}"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.environment[0].name_servers
}

# Common records for the environment
resource "aws_route53_record" "www" {
  count = var.create_env_zone ? 1 : 0
  
  zone_id = aws_route53_zone.environment[0].zone_id
  name    = "www.${var.environment}.${var.domain_name}"
  type    = "A"
  
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  count = var.create_env_zone && var.create_api_record ? 1 : 0
  
  zone_id = aws_route53_zone.environment[0].zone_id
  name    = "api.${var.environment}.${var.domain_name}"
  type    = "A"
  
  alias {
    name                   = var.api_dns_name
    zone_id                = var.api_zone_id
    evaluate_target_health = true
  }
}
