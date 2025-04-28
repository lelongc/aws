output "state_machine_id" {
  description = "ID of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.id
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.name
}

output "role_arn" {
  description = "ARN of the IAM role used by the Step Functions state machine"
  value       = aws_iam_role.step_function.arn
}

output "role_name" {
  description = "Name of the IAM role used by the Step Functions state machine"
  value       = aws_iam_role.step_function.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group for Step Functions"
  value       = aws_cloudwatch_log_group.step_function.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for Step Functions"
  value       = aws_cloudwatch_log_group.step_function.name
}

output "event_rule_arn" {
  description = "ARN of the EventBridge rule for Step Functions"
  value       = var.enable_event_trigger ? aws_cloudwatch_event_rule.step_function[0].arn : null
}

output "event_rule_id" {
  description = "ID of the EventBridge rule for Step Functions"
  value       = var.enable_event_trigger ? aws_cloudwatch_event_rule.step_function[0].id : null
}
