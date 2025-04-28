output "alb_protection_id" {
  description = "ID of the ALB Shield protection"
  value       = var.enable_shield_advanced && var.alb_arn != null ? aws_shield_protection.alb[0].id : null
}

output "cloudfront_protection_id" {
  description = "ID of the CloudFront Shield protection"
  value       = var.enable_shield_advanced && var.cloudfront_arn != null ? aws_shield_protection.cloudfront[0].id : null
}

output "route53_protection_id" {
  description = "ID of the Route53 Shield protection"
  value       = var.enable_shield_advanced && var.route53_hosted_zone_id != null ? aws_shield_protection.route53[0].id : null
}

output "elastic_ip_protection_id" {
  description = "ID of the Elastic IP Shield protection"
  value       = var.enable_shield_advanced && var.elastic_ip_allocation_id != null ? aws_shield_protection.elastic_ip[0].id : null
}

output "protection_group_id" {
  description = "ID of the Shield protection group"
  value       = var.enable_shield_advanced && var.create_protection_group ? aws_shield_protection_group.this[0].id : null
}

output "ddos_alerts_topic_arn" {
  description = "ARN of the SNS topic for DDoS alerts"
  value       = var.enable_shield_advanced && var.create_ddos_alarm ? aws_sns_topic.ddos_alerts[0].arn : null
}

output "ddos_alarm_arn" {
  description = "ARN of the CloudWatch alarm for DDoS detection"
  value       = var.enable_shield_advanced && var.create_ddos_alarm ? aws_cloudwatch_metric_alarm.ddos_detected_alarm[0].arn : null
}
