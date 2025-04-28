provider "aws" {
  region = var.region
}

# Shield Advanced subscription
resource "aws_shield_protection" "alb" {
  count        = var.enable_shield_advanced && var.alb_arn != null ? 1 : 0
  name         = "${var.project}-${var.environment}-alb-protection"
  resource_arn = var.alb_arn
}

resource "aws_shield_protection" "cloudfront" {
  count        = var.enable_shield_advanced && var.cloudfront_arn != null ? 1 : 0
  name         = "${var.project}-${var.environment}-cloudfront-protection"
  resource_arn = var.cloudfront_arn
}

resource "aws_shield_protection" "route53" {
  count        = var.enable_shield_advanced && var.route53_hosted_zone_id != null ? 1 : 0
  name         = "${var.project}-${var.environment}-route53-protection"
  resource_arn = "arn:aws:route53:::hostedzone/${var.route53_hosted_zone_id}"
}

resource "aws_shield_protection" "elastic_ip" {
  count        = var.enable_shield_advanced && var.elastic_ip_allocation_id != null ? 1 : 0
  name         = "${var.project}-${var.environment}-eip-protection"
  resource_arn = "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:eip-allocation/${var.elastic_ip_allocation_id}"
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# Shield Advanced Protection Group
resource "aws_shield_protection_group" "this" {
  count = var.enable_shield_advanced && var.create_protection_group ? 1 : 0
  
  protection_group_id = "${var.project}-${var.environment}-protection-group"
  aggregation         = var.protection_group_aggregation
  pattern             = var.protection_group_pattern
  
  members = flatten([
    var.alb_arn != null ? [aws_shield_protection.alb[0].id] : [],
    var.cloudfront_arn != null ? [aws_shield_protection.cloudfront[0].id] : [],
    var.route53_hosted_zone_id != null ? [aws_shield_protection.route53[0].id] : [],
    var.elastic_ip_allocation_id != null ? [aws_shield_protection.elastic_ip[0].id] : []
  ])
}

# SNS Topic for DDoS alert notifications
resource "aws_sns_topic" "ddos_alerts" {
  count = var.enable_shield_advanced && var.create_ddos_alarm ? 1 : 0
  
  name = "${var.project}-${var.environment}-ddos-alerts"
  
  tags = {
    Name        = "${var.project}-${var.environment}-ddos-alerts"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# CloudWatch Metric Alarm for DDoS attacks
resource "aws_cloudwatch_metric_alarm" "ddos_detected_alarm" {
  count = var.enable_shield_advanced && var.create_ddos_alarm ? 1 : 0
  
  alarm_name          = "${var.project}-${var.environment}-ddos-attack-detected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm monitors for DDoS attacks"
  alarm_actions       = [aws_sns_topic.ddos_alerts[0].arn]
  ok_actions          = [aws_sns_topic.ddos_alerts[0].arn]
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    ResourceArn = var.alb_arn
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
