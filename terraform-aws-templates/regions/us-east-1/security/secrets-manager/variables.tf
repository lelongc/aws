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

variable "secrets" {
  description = "List of secrets to create in Secrets Manager"
  type = list(object({
    name                    = string
    description             = optional(string)
    kms_key_id              = optional(string)
    recovery_window_in_days = optional(number, 30)
    value                   = optional(string)
    value_map               = optional(map(string))
    policy                  = optional(string)
    generate_random_password = optional(bool, false)
    password_length         = optional(number, 16)
    include_special_chars   = optional(bool, true)
    special_chars           = optional(string, "!@#$%^&*()-_=+[]{}<>:?")
    tags                    = optional(map(string), {})
  }))
  default = []
  
  validation {
    condition     = length([for s in var.secrets : true if (s.value == null && s.value_map == null && s.generate_random_password == false)]) == 0
    error_message = "Each secret must have either a value, value_map, or generate_random_password set to true."
  }
}

variable "global_secret_policy" {
  description = "Global policy to apply to all secrets"
  type        = string
  default     = null
}
