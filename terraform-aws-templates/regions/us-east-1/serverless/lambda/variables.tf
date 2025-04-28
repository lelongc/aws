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

variable "functions" {
  description = "List of Lambda functions to create"
  type        = any
  default     = []
}

variable "log_retention_days" {
  description = "Number of days to retain Lambda logs"
  type        = number
  default     = 30
}

variable "additional_policy_arns" {
  description = "List of additional policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}

variable "event_source_mappings" {
  description = "List of event source mappings for Lambda functions"
  type        = any
  default     = []
}

variable "function_permissions" {
  description = "List of permissions for Lambda functions"
  type        = any
  default     = []
}
