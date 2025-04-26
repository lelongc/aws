variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "api"
}

variable "environment" {
  description = "Environment (dev, test, prod, etc)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "example"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "terraform"
}

# Lambda Configuration
variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "Lambda function created by Terraform"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "filename" {
  description = "Path to the function's deployment package"
  type        = string
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Function memory in MB"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tracing_mode" {
  description = "X-Ray tracing mode (PassThrough or Active)"
  type        = string
  default     = "PassThrough"
}

variable "vpc_subnet_ids" {
  description = "List of subnet IDs for Lambda VPC config"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for Lambda VPC config"
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "Lambda CloudWatch Logs retention in days"
  type        = number
  default     = 14
}

# IAM Policies
variable "additional_lambda_policies" {
  description = "List of additional IAM policy ARNs to attach to Lambda role"
  type        = list(string)
  default     = []
}

variable "custom_lambda_policy" {
  description = "Custom IAM policy document in JSON format"
  type        = any
  default     = {}
}

# API Gateway Configuration
variable "api_gateway_endpoint_type" {
  description = "API Gateway endpoint type (REGIONAL, PRIVATE, or EDGE)"
  type        = string
  default     = "REGIONAL"
}

variable "api_path_part" {
  description = "Path part for the API resource"
  type        = string
  default     = "resource"
}

variable "http_method" {
  description = "HTTP method for the API Gateway method"
  type        = string
  default     = "POST"
}

variable "authorization_type" {
  description = "Authorization type for the API Gateway method (NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
  type        = string
  default     = "NONE"
}

variable "authorizer_id" {
  description = "Authorizer ID for the API Gateway method (if authorization_type is CUSTOM or COGNITO_USER_POOLS)"
  type        = string
  default     = null
}

variable "request_parameters" {
  description = "Request parameters for the API Gateway method"
  type        = map(bool)
  default     = {}
}

variable "api_stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "v1"
}

variable "xray_tracing_enabled" {
  description = "Enable X-Ray tracing for API Gateway"
  type        = bool
  default     = false
}

variable "api_logging_enabled" {
  description = "Enable data trace logging for API Gateway"
  type        = bool
  default     = false
}

variable "throttling_burst_limit" {
  description = "API Gateway throttling burst limit"
  type        = number
  default     = 5
}

variable "throttling_rate_limit" {
  description = "API Gateway throttling rate limit"
  type        = number
  default     = 10
}
