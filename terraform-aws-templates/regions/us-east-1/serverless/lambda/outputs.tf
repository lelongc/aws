output "function_names" {
  description = "Map of function names to function names"
  value       = { for name, function in aws_lambda_function.functions : name => function.function_name }
}

output "function_arns" {
  description = "Map of function names to function ARNs"
  value       = { for name, function in aws_lambda_function.functions : name => function.arn }
}

output "function_invoke_arns" {
  description = "Map of function names to function invoke ARNs"
  value       = { for name, function in aws_lambda_function.functions : name => function.invoke_arn }
}

output "function_versions" {
  description = "Map of function names to function versions"
  value       = { for name, function in aws_lambda_function.functions : name => function.version }
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda functions"
  value       = aws_iam_role.lambda.arn
}

output "lambda_role_name" {
  description = "Name of the IAM role used by Lambda functions"
  value       = aws_iam_role.lambda.name
}

output "event_source_mapping_ids" {
  description = "Map of function-source pairs to event source mapping IDs"
  value       = { for key, mapping in aws_lambda_event_source_mapping.event_sources : key => mapping.id }
}
