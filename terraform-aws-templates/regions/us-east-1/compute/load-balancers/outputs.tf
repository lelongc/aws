output "alb_id" {
  description = "ID of the ALB"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Route 53 zone ID of the ALB"
  value       = aws_lb.alb.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.main.name
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.enable_https ? aws_lb_listener.https[0].arn : null
}

output "nlb_id" {
  description = "ID of the NLB"
  value       = var.create_nlb ? aws_lb.nlb[0].id : null
}

output "nlb_arn" {
  description = "ARN of the NLB"
  value       = var.create_nlb ? aws_lb.nlb[0].arn : null
}

output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = var.create_nlb ? aws_lb.nlb[0].dns_name : null
}

output "nlb_target_group_arn" {
  description = "ARN of the NLB target group"
  value       = var.create_nlb ? aws_lb_target_group.nlb[0].arn : null
}
