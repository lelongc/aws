output "api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_arn" {
  description = "ARN of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.arn
}

output "api_root_resource_id" {
  description = "ID of the API Gateway REST API root resource"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "api_execution_arn" {
  description = "Execution ARN of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "stage_id" {
  description = "ID of the API Gateway deployment stage"
  value       = aws_api_gateway_stage.this.id
}

output "stage_arn" {
  description = "ARN of the API Gateway deployment stage"
  value       = aws_api_gateway_stage.this.arn
}

output "invoke_url" {
  description = "URL to invoke the API"
  value       = "${aws_api_gateway_deployment.this.invoke_url}${aws_api_gateway_stage.this.stage_name}"
}

output "custom_domain_url" {
  description = "Custom domain URL for the API Gateway"
  value       = var.domain_name != "" ? "https://${var.domain_name}/${var.base_path}" : null
}

output "regional_domain_name" {
  description = "Regional domain name of the API Gateway"
  value       = var.domain_name != "" ? aws_api_gateway_domain_name.this[0].regional_domain_name : null
}

output "api_keys" {
  description = "Map of API key names to IDs"
  value       = { for name, key in aws_api_gateway_api_key.keys : name => key.id }
}

output "usage_plan_id" {
  description = "ID of the API Gateway usage plan"
  value       = var.create_usage_plan ? aws_api_gateway_usage_plan.this[0].id : null
}

output "resources" {
  description = "Map of API Gateway resource path parts to resource IDs"
  value       = { for key, resource in aws_api_gateway_resource.resources : key => resource.id }
}
