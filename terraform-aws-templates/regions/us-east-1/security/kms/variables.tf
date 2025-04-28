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

variable "kms_keys" {
  description = "List of KMS keys to create"
  type = list(object({
    name                    = string
    description             = optional(string)
    deletion_window_in_days = optional(number, 30)
    key_usage               = optional(string, "ENCRYPT_DECRYPT")
    customer_master_key_spec = optional(string, "SYMMETRIC_DEFAULT")
    is_enabled              = optional(bool, true)
    enable_key_rotation     = optional(bool, true)
    policy                  = optional(string)
    key_users               = optional(list(string), [])
    tags                    = optional(map(string), {})
    grants = optional(list(object({
      name              = string
      grantee_principal = string
      operations        = list(string)
    })), [])
  }))
  default = []
}
