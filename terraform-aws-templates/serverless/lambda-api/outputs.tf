output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda IAM role"
  value       = aws_iam_role.lambda.name
}

output "rest_api_id" {
  description = "ID of the REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "rest_api_execution_arn" {
  description = "Execution ARN of the REST API"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "api_endpoint" {
  description = "Endpoint of the deployed API"
  value       = "${aws_api_gateway_stage.this.invoke_url}/${var.api_path_part}"
}

output "api_stage_name" {
  description = "Name of the API stage"
  value       = aws_api_gateway_stage.this.stage_name
}

output "api_stage_execution_arn" {
  description = "Execution ARN of the API stage"
  value       = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_stage.this.stage_name}"
}
