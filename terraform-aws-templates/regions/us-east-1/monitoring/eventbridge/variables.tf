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

variable "create_custom_event_bus" {
  description = "Whether to create a custom event bus"
  type        = bool
  default     = false
}

variable "event_rules" {
  description = "List of EventBridge rules to create"
  type = list(object({
    name                = string
    description         = optional(string)
    event_pattern       = optional(string)
    schedule_expression = optional(string)
    role_arn            = optional(string)
    enabled             = optional(bool, true)
    tags                = optional(map(string), {})
  }))
  default = []
  
  validation {
    condition     = length([for rule in var.event_rules : true if rule.event_pattern == null && rule.schedule_expression == null]) == 0
    error_message = "Either event_pattern or schedule_expression must be specified for each rule."
  }
}

variable "event_targets" {
  description = "List of EventBridge targets"
  type = list(any)
  default = []
}

variable "create_event_archive" {
  description = "Whether to create an event archive"
  type        = bool
  default     = false
}

variable "archive_retention_days" {
  description = "Number of days to retain events in the archive"
  type        = number
  default     = 90
}

variable "archive_event_pattern" {
  description = "Event pattern for the archive"
  type        = string
  default     = null
}

variable "event_permissions" {
  description = "List of permissions for the event bus"
  type = list(object({
    principal       = string
    statement_id    = optional(string)
    condition_key   = optional(string)
    condition_value = string
  }))
  default = []
}
