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

variable "waf_scope" {
  description = "Scope of the WAF (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
}

variable "enable_aws_managed_rules" {
  description = "Enable AWS common core rule set"
  type        = bool
  default     = true
}

variable "enable_sql_injection_protection" {
  description = "Enable SQL injection protection"
  type        = bool
  default     = true
}

variable "enable_bot_control" {
  description = "Enable bot control rule set"
  type        = bool
  default     = false
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Requests per 5 minutes per IP address"
  type        = number
  default     = 1000
}

variable "blocked_ip_addresses" {
  description = "List of IP addresses to block (CIDR format)"
  type        = list(string)
  default     = []
}

variable "blocked_countries" {
  description = "List of country codes to block"
  type        = list(string)
  default     = []
}

variable "custom_rules" {
  description = "List of custom WAF rules"
  type        = any
  default     = []
}

variable "alb_arn" {
  description = "ARN of the ALB to associate with the WAF"
  type        = string
  default     = null
}

variable "cloudfront_id" {
  description = "ID of the CloudFront distribution to associate with the WAF"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable WAF logging"
  type        = bool
  default     = false
}

variable "log_destination_arn" {
  description = "ARN of the log destination (S3 bucket, CloudWatch, Kinesis)"
  type        = string
  default     = null
}

variable "redacted_fields" {
  description = "List of fields to redact from logs"
  type        = list(any)
  default     = []
}
