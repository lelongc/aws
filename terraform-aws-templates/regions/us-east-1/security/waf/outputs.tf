output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_capacity" {
  description = "Current capacity of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "blocked_ips_id" {
  description = "ID of the blocked IPs set"
  value       = length(var.blocked_ip_addresses) > 0 ? aws_wafv2_ip_set.blocked_ips[0].id : null
}

output "blocked_ips_arn" {
  description = "ARN of the blocked IPs set"
  value       = length(var.blocked_ip_addresses) > 0 ? aws_wafv2_ip_set.blocked_ips[0].arn : null
}

output "logging_enabled" {
  description = "Whether WAF logging is enabled"
  value       = var.enable_logging
}
