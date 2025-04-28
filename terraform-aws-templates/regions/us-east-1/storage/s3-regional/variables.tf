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

variable "buckets" {
  description = "List of S3 buckets to create"
  type = list(object({
    name               = string
    versioning_enabled = optional(bool, false)
    block_public_access = optional(bool, true)
    kms_key_id         = optional(string)
    bucket_key_enabled = optional(bool, true)
    policy             = optional(string)
    cors_rules         = optional(list(object({
      allowed_headers = list(string)
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers  = optional(list(string), [])
      max_age_seconds = optional(number, 3000)
    })))
    lifecycle_rules = optional(list(object({
      id     = string
      status = string
      transitions = optional(list(object({
        days          = number
        storage_class = string
      })), [])
      expiration = optional(object({
        days = number
      }))
      noncurrent_version_transitions = optional(list(object({
        days          = number
        storage_class = string
      })), [])
      noncurrent_version_expiration = optional(object({
        days = number
      }))
    })), [])
    tags = optional(map(string), {})
  }))
  default = []
}
