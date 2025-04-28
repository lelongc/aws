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

variable "create_dashboard" {
  description = "Whether to create a CloudWatch dashboard"
  type        = bool
  default     = false
}

variable "dashboard_body" {
  description = "JSON string representing the dashboard body"
  type        = string
  default     = null
}

variable "load_balancer_name" {
  description = "Name of the load balancer for dashboard metrics"
  type        = string
  default     = ""
}

variable "alarms" {
  description = "List of CloudWatch alarms to create"
  type = list(object({
    name                = string
    description         = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_actions       = list(string)
    ok_actions          = optional(list(string), [])
    dimensions          = map(string)
    treat_missing_data  = optional(string, "missing")
  }))
  default = []
}

variable "log_groups" {
  description = "List of CloudWatch log groups to create"
  type = list(object({
    name              = string
    name_prefix       = optional(string, "")
    retention_in_days = optional(number)
    kms_key_id        = optional(string)
    tags              = optional(map(string), {})
  }))
  default = []
}

variable "default_log_retention_days" {
  description = "Default retention period for log groups in days"
  type        = number
  default     = 30
}

variable "metric_filters" {
  description = "List of CloudWatch log metric filters"
  type = list(object({
    name           = string
    pattern        = string
    log_group_name = string
    metric_name    = string
    namespace      = string
    metric_value   = string
    default_value  = optional(string)
    unit           = optional(string)
  }))
  default = []
}

variable "composite_alarms" {
  description = "List of CloudWatch composite alarms"
  type = list(object({
    name            = string
    description     = string
    alarm_rule      = string
    alarm_actions   = list(string)
    ok_actions      = optional(list(string), [])
    actions_enabled = optional(bool, true)
  }))
  default = []
}
