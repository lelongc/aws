provider "aws" {
  region = var.region
}

# EventBridge Event Bus
resource "aws_cloudwatch_event_bus" "event_bus" {
  count = var.create_custom_event_bus ? 1 : 0
  
  name = "${var.project}-${var.environment}-event-bus"
  
  tags = {
    Name        = "${var.project}-${var.environment}-event-bus"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# EventBridge Rules
resource "aws_cloudwatch_event_rule" "rules" {
  for_each = { for rule in var.event_rules : rule.name => rule }
  
  name        = "${var.project}-${var.environment}-${each.value.name}"
  description = lookup(each.value, "description", "EventBridge rule for ${each.value.name}")
  
  event_bus_name = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[0].name : "default"
  
  # Choose between event pattern and schedule expression
  event_pattern = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)
  
  role_arn     = lookup(each.value, "role_arn", null)
  state        = lookup(each.value, "enabled", true) ? "ENABLED" : "DISABLED"
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    lookup(each.value, "tags", {})
  )
}

# EventBridge Targets
resource "aws_cloudwatch_event_target" "targets" {
  for_each = { 
    for idx, target in var.event_targets : 
    "${target.rule}-${idx}" => target 
  }
  
  rule      = aws_cloudwatch_event_rule.rules[each.value.rule].name
  target_id = lookup(each.value, "id", "${each.value.rule}-${each.value.arn}")
  arn       = each.value.arn
  
  event_bus_name = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[0].name : "default"
  
  role_arn = lookup(each.value, "role_arn", null)
  
  # Input transformer if needed
  dynamic "input_transformer" {
    for_each = lookup(each.value, "input_transformer", null) != null ? [each.value.input_transformer] : []
    content {
      input_paths    = input_transformer.value.input_paths
      input_template = input_transformer.value.input_template
    }
  }
  
  # Input if needed
  input     = lookup(each.value, "input", null)
  input_path = lookup(each.value, "input_path", null)
  
  # Run command target
  dynamic "run_command_targets" {
    for_each = lookup(each.value, "run_command_targets", [])
    content {
      key    = run_command_targets.value.key
      values = run_command_targets.value.values
    }
  }
  
  # ECS target
  dynamic "ecs_target" {
    for_each = lookup(each.value, "ecs_target", null) != null ? [each.value.ecs_target] : []
    content {
      task_count          = ecs_target.value.task_count
      task_definition_arn = ecs_target.value.task_definition_arn
      launch_type         = lookup(ecs_target.value, "launch_type", "FARGATE")
      
      network_configuration {
        subnets          = ecs_target.value.network_configuration.subnets
        security_groups  = lookup(ecs_target.value.network_configuration, "security_groups", [])
        assign_public_ip = lookup(ecs_target.value.network_configuration, "assign_public_ip", false)
      }
    }
  }
  
  # Batch job target
  dynamic "batch_target" {
    for_each = lookup(each.value, "batch_target", null) != null ? [each.value.batch_target] : []
    content {
      job_definition = batch_target.value.job_definition
      job_name       = batch_target.value.job_name
      array_size     = lookup(batch_target.value, "array_size", null)
      job_attempts   = lookup(batch_target.value, "job_attempts", null)
    }
  }
  
  # SQS target
  dynamic "sqs_target" {
    for_each = lookup(each.value, "sqs_target", null) != null ? [each.value.sqs_target] : []
    content {
      message_group_id = sqs_target.value.message_group_id
    }
  }
  
  # Retry policy
  dynamic "retry_policy" {
    for_each = lookup(each.value, "retry_policy", null) != null ? [each.value.retry_policy] : []
    content {
      maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
    }
  }
  
  # Dead letter config
  dynamic "dead_letter_config" {
    for_each = lookup(each.value, "dead_letter_arn", null) != null ? [1] : []
    content {
      arn = each.value.dead_letter_arn
    }
  }
}

# EventBridge Archive
resource "aws_cloudwatch_event_archive" "archive" {
  count = var.create_event_archive ? 1 : 0
  
  name             = "${var.project}-${var.environment}-archive"
  event_source_arn = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[0].arn : "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:event-bus/default"
  
  description      = "Archive for ${var.project}-${var.environment} events"
  retention_days   = var.archive_retention_days
  
  event_pattern = var.archive_event_pattern
}

# EventBridge Permission
resource "aws_cloudwatch_event_permission" "permissions" {
  for_each = var.create_custom_event_bus ? { for perm in var.event_permissions : perm.principal => perm } : {}
  
  principal    = each.value.principal
  statement_id = lookup(each.value, "statement_id", "AllowAccount${each.value.principal}")
  
  event_bus_name = aws_cloudwatch_event_bus.event_bus[0].name
  
  action    = "events:PutEvents"
  condition {
    key   = lookup(each.value, "condition_key", "aws:PrincipalOrgID")
    type  = "StringEquals"
    value = each.value.condition_value
  }
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}
