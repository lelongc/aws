variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "api_description" {
  description = "Description for the API Gateway"
  type        = string
  default     = "API Gateway"
}

variable "endpoint_type" {
  description = "Endpoint type for API Gateway (REGIONAL, EDGE, or PRIVATE)"
  type        = string
  default     = "REGIONAL"
}

variable "api_policy" {
  description = "IAM policy for the API Gateway"
  type        = string
  default     = null
}

variable "api_paths" {
  description = "List of API Gateway resource paths"
  type = list(object({
    path_part = string
    parent_id = optional(string)
  }))
  default = []
}

variable "api_methods" {
  description = "List of API Gateway methods"
  type = list(object({
    resource_path_part  = string
    http_method         = string
    authorization_type  = string
    authorizer_id       = optional(string)
    api_key_required    = optional(bool)
    request_parameters  = optional(map(bool))
    request_models      = optional(map(string))
    integration_type    = string
    integration_uri     = string
    integration_http_method = optional(string)
    integration_request_parameters = optional(map(string))
    integration_request_templates = optional(map(string))
    integration_credentials = optional(string)
    cache_key_parameters = optional(list(string))
    cache_namespace      = optional(string)
    response_status_codes = list(string)
  }))
  default = []
}

variable "binary_media_types" {
  description = "List of binary media types supported by the API"
  type        = list(string)
  default     = []
}

variable "enable_cors" {
  description = "Enable CORS for API Gateway"
  type        = bool
  default     = true
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token"]
}

variable "cors_allow_methods" {
  description = "List of allowed methods for CORS"
  type        = list(string)
  default     = ["OPTIONS", "GET", "POST", "PUT", "DELETE"]
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_expose_headers" {
  description = "List of exposed headers for CORS"
  type        = list(string)
  default     = []
}

variable "cors_max_age" {
  description = "Expiration time for CORS in seconds"
  type        = number
  default     = 7200
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "v1"
}

variable "enable_cache" {
  description = "Enable API Gateway cache"
  type        = bool
  default     = false
}

variable "cache_cluster_size" {
  description = "Size of the API Gateway cache cluster"
  type        = string
  default     = "0.5"
}

variable "enable_logging" {
  description = "Enable API Gateway logging"
  type        = bool
  default     = true
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch log group for API Gateway"
  type        = string
  default     = null
}

variable "log_format" {
  description = "Format of the API Gateway logs"
  type        = string
  default     = "{ \"requestId\":\"$context.requestId\", \"ip\":\"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\", \"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
}

variable "xray_tracing_enabled" {
  description = "Enable X-Ray tracing for API Gateway"
  type        = bool
  default     = false
}

variable "stage_variables" {
  description = "Variables for the API Gateway stage"
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  description = "Custom domain name for the API Gateway"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for the custom domain"
  type        = string
  default     = null
}

variable "base_path" {
  description = "Base path for the API Gateway domain mapping"
  type        = string
  default     = ""
}

variable "create_usage_plan" {
  description = "Create API Gateway usage plan"
  type        = bool
  default     = false
}

variable "quota_limit" {
  description = "Quota limit for the usage plan"
  type        = number
  default     = 5000
}

variable "quota_period" {
  description = "Quota period for the usage plan (DAY, WEEK, or MONTH)"
  type        = string
  default     = "MONTH"
}

variable "throttle_burst_limit" {
  description = "Throttle burst limit for the usage plan"
  type        = number
  default     = 200
}

variable "throttle_rate_limit" {
  description = "Throttle rate limit for the usage plan"
  type        = number
  default     = 100
}

variable "api_keys" {
  description = "List of API keys to create"
  type        = list(string)
  default     = []
}
