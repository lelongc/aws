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

variable "tables" {
  description = "List of DynamoDB tables to create"
  type = list(object({
    name                    = string
    billing_mode            = string
    read_capacity           = optional(number)
    write_capacity          = optional(number)
    hash_key                = string
    range_key               = optional(string)
    attributes              = list(object({
      name = string
      type = string
    }))
    global_secondary_indexes = optional(list(object({
      name               = string
      hash_key           = string
      range_key          = optional(string)
      read_capacity      = optional(number)
      write_capacity     = optional(number)
      projection_type    = string
      non_key_attributes = optional(list(string))
    })))
    local_secondary_indexes = optional(list(object({
      name               = string
      range_key          = string
      projection_type    = string
      non_key_attributes = optional(list(string))
    })))
    ttl_attribute          = optional(string)
    point_in_time_recovery = optional(bool, true)
    server_side_encryption = optional(bool, true)
    kms_key_arn            = optional(string)
    autoscaling_read       = optional(bool, false)
    autoscaling_read_min   = optional(number, 5)
    autoscaling_read_max   = optional(number, 100)
    autoscaling_read_target = optional(number, 70)
    autoscaling_write      = optional(bool, false)
    autoscaling_write_min  = optional(number, 5)
    autoscaling_write_max  = optional(number, 100)
    autoscaling_write_target = optional(number, 70)
    tags                   = optional(map(string), {})
  }))
  default = []
}
