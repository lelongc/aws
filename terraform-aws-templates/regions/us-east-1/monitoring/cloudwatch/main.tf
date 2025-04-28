provider "aws" {
  region = var.region
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  count = var.create_dashboard ? 1 : 0
  
  dashboard_name = "${var.project}-${var.environment}-dashboard"
  
  dashboard_body = var.dashboard_body != null ? var.dashboard_body : jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.project}-${var.environment}", { "stat": "Average" }]
          ]
          period = 300
          region = var.region
          title  = "EC2 CPU Utilization"
          view   = "timeSeries"
          stacked = false
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.load_balancer_name, { "stat": "Sum" }]
          ]
          period = 300
          region = var.region
          title  = "ALB Request Count"
          view   = "timeSeries"
        }
      }
    ]
  })
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = { for alarm in var.alarms : alarm.name => alarm }

  alarm_name          = "${var.project}-${var.environment}-${each.value.name}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.description
  alarm_actions       = each.value.alarm_actions
  ok_actions          = lookup(each.value, "ok_actions", [])
  
  dimensions = each.value.dimensions
  
  treat_missing_data = lookup(each.value, "treat_missing_data", "missing")
  
  tags = {
    Name        = "${var.project}-${var.environment}-${each.value.name}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "log_groups" {
  for_each = { for log in var.log_groups : log.name => log }
  
  name              = lookup(each.value, "name_prefix", "") != "" ? "${each.value.name_prefix}${each.value.name}" : each.value.name
  retention_in_days = lookup(each.value, "retention_in_days", var.default_log_retention_days)
  kms_key_id        = lookup(each.value, "kms_key_id", null)
  
  tags = merge(
    {
      Name        = each.value.name
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    lookup(each.value, "tags", {})
  )
}

# CloudWatch Metric Filters
resource "aws_cloudwatch_log_metric_filter" "metric_filters" {
  for_each = { 
    for filter in var.metric_filters : 
    "${filter.log_group_name}-${filter.name}" => filter 
  }
  
  name           = "${var.project}-${var.environment}-${each.value.name}"
  pattern        = each.value.pattern
  log_group_name = each.value.log_group_name
  
  metric_transformation {
    name          = each.value.metric_name
    namespace     = each.value.namespace
    value         = each.value.metric_value
    default_value = lookup(each.value, "default_value", null)
    unit          = lookup(each.value, "unit", null)
  }
}

# CloudWatch Composite Alarms
resource "aws_cloudwatch_composite_alarm" "composite_alarms" {
  for_each = { for alarm in var.composite_alarms : alarm.name => alarm }
  
  alarm_name        = "${var.project}-${var.environment}-${each.value.name}"
  alarm_description = each.value.description
  alarm_rule        = each.value.alarm_rule
  
  alarm_actions = each.value.alarm_actions
  ok_actions    = lookup(each.value, "ok_actions", [])
  
  actions_enabled = lookup(each.value, "actions_enabled", true)
  
  tags = {
    Name        = "${var.project}-${var.environment}-${each.value.name}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
