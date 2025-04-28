output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = var.create_dashboard ? aws_cloudwatch_dashboard.main[0].dashboard_name : null
}

output "dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = var.create_dashboard ? aws_cloudwatch_dashboard.main[0].dashboard_arn : null
}

output "alarm_arns" {
  description = "Map of alarm names to ARNs"
  value = {
    for name, alarm in aws_cloudwatch_metric_alarm.alarms : name => alarm.arn
  }
}

output "alarm_ids" {
  description = "Map of alarm names to IDs"
  value = {
    for name, alarm in aws_cloudwatch_metric_alarm.alarms : name => alarm.id
  }
}

output "log_group_arns" {
  description = "Map of log group names to ARNs"
  value = {
    for name, log_group in aws_cloudwatch_log_group.log_groups : name => log_group.arn
  }
}

output "log_group_names" {
  description = "Map of log group names to names"
  value = {
    for name, log_group in aws_cloudwatch_log_group.log_groups : name => log_group.name
  }
}

output "metric_filter_ids" {
  description = "Map of metric filter names to IDs"
  value = {
    for key, filter in aws_cloudwatch_log_metric_filter.metric_filters : key => filter.id
  }
}

output "composite_alarm_arns" {
  description = "Map of composite alarm names to ARNs"
  value = {
    for name, alarm in aws_cloudwatch_composite_alarm.composite_alarms : name => alarm.arn
  }
}
