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

variable "lambda_arns" {
  description = "List of Lambda ARNs that the Step Functions can invoke"
  type        = list(string)
  default     = ["*"]
}

variable "step_function_policy" {
  description = "IAM policy for Step Functions state machine (JSON)"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Number of days to retain Step Functions logs"
  type        = number
  default     = 30
}

variable "state_machine_definition" {
  description = "JSON definition of the state machine"
  type        = string
}

variable "include_execution_data" {
  description = "Whether to include execution data in the CloudWatch logs"
  type        = bool
  default     = true
}

variable "logging_level" {
  description = "Logging level for Step Functions (ALL, ERROR, FATAL)"
  type        = string
  default     = "ALL"
}

variable "tracing_enabled" {
  description = "Whether to enable X-Ray tracing for Step Functions"
  type        = bool
  default     = false
}

variable "step_function_type" {
  description = "Type of the Step Functions state machine (STANDARD or EXPRESS)"
  type        = string
  default     = "STANDARD"
}

variable "enable_event_trigger" {
  description = "Whether to enable EventBridge rule trigger for Step Functions"
  type        = bool
  default     = false
}

variable "event_schedule_expression" {
  description = "Schedule expression for EventBridge rule (cron or rate)"
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "Event pattern for EventBridge rule"
  type        = string
  default     = null
}

variable "event_role_arn" {
  description = "ARN of the IAM role for the EventBridge to invoke Step Functions"
  type        = string
  default     = null
}

variable "event_input_transformer" {
  description = "Input transformer for the EventBridge event"
  type = object({
    input_paths    = map(string)
    input_template = string
  })
  default = null
}
