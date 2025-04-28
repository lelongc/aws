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

variable "topics" {
  description = "List of SNS topics to create"
  type = list(object({
    name                        = string
    display_name                = optional(string)
    kms_master_key_id           = optional(string)
    fifo_topic                  = optional(bool, false)
    content_based_deduplication = optional(bool, false)
    delivery_policy             = optional(string)
    policy                      = optional(string)
    tags                        = optional(map(string), {})
  }))
  default = []
}

variable "subscriptions" {
  description = "List of SNS subscriptions"
  type = list(object({
    topic_name                      = string
    protocol                        = string
    endpoint                        = string
    filter_policy                   = optional(string)
    endpoint_auto_confirms          = optional(bool, false)
    confirmation_timeout_in_minutes = optional(number)
    delivery_policy                 = optional(string)
    raw_message_delivery            = optional(bool, false)
  }))
  default = []
  
  validation {
    condition = alltrue([
      for sub in var.subscriptions : 
      contains(["http", "https", "email", "email-json", "sms", "sqs", "application", "lambda", "firehose"], sub.protocol)
    ])
    error_message = "Protocol must be one of: http, https, email, email-json, sms, sqs, application, lambda, or firehose."
  }
}
