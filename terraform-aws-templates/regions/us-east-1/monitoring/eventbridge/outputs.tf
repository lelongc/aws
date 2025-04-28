output "event_bus_name" {
  description = "Name of the EventBridge event bus"
  value       = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[0].name : "default"
}

output "event_bus_arn" {
  description = "ARN of the EventBridge event bus"
  value       = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[0].arn : null
}

output "rule_arns" {
  description = "Map of rule names to ARNs"
  value = {
    for name, rule in aws_cloudwatch_event_rule.rules : name => rule.arn
  }
}

output "rule_ids" {
  description = "Map of rule names to IDs"
  value = {
    for name, rule in aws_cloudwatch_event_rule.rules : name => rule.id
  }
}

output "target_ids" {
  description = "Map of target keys to IDs"
  value = {
    for key, target in aws_cloudwatch_event_target.targets : key => target.target_id
  }
}

output "archive_arn" {
  description = "ARN of the EventBridge archive"
  value       = var.create_event_archive ? aws_cloudwatch_event_archive.archive[0].arn : null
}

output "archive_name" {
  description = "Name of the EventBridge archive"
  value       = var.create_event_archive ? aws_cloudwatch_event_archive.archive[0].name : null
}
