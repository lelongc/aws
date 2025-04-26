variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "app"
}

variable "environment" {
  description = "Environment (dev, test, prod, etc)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "example"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "terraform"
}

# Table configuration
variable "billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity units for the table (used when billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for the table (used when billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Partition key attribute name"
  type        = string
}

variable "range_key" {
  description = "Sort key attribute name"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions for the DynamoDB table"
  type = list(object({
    name = string
    type = string  # S, N, or B (string, number, or binary)
  }))
}

# Time to Live (TTL)
variable "ttl_enabled" {
  description = "Whether TTL is enabled"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Name of the TTL attribute"
  type        = string
  default     = "ttl"
}

# Secondary indexes
variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string        # ALL, KEYS_ONLY, or INCLUDE
    non_key_attributes = list(string)
    read_capacity  = number
    write_capacity = number
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary indexes"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = string        # ALL, KEYS_ONLY, or INCLUDE
    non_key_attributes = list(string)
  }))
  default = []
}

variable "gsi_read_capacity" {
  description = "Read capacity for GSIs (when not specified in the global_secondary_indexes)"
  type        = number
  default     = 5
}

variable "gsi_write_capacity" {
  description = "Write capacity for GSIs (when not specified in the global_secondary_indexes)"
  type        = number
  default     = 5
}

# Autoscaling
variable "enable_autoscaling" {
  description = "Enable autoscaling for the table (only valid when billing_mode is PROVISIONED)"
  type        = bool
  default     = false
}

variable "read_capacity_max" {
  description = "Maximum read capacity when autoscaling is enabled"
  type        = number
  default     = 100
}

variable "write_capacity_max" {
  description = "Maximum write capacity when autoscaling is enabled"
  type        = number
  default     = 100
}

variable "autoscaling_read_target" {
  description = "Target utilization percentage for read capacity autoscaling"
  type        = number
  default     = 70
}

variable "autoscaling_write_target" {
  description = "Target utilization percentage for write capacity autoscaling"
  type        = number
  default     = 70
}

variable "autoscaling_scale_in_cooldown" {
  description = "Cooldown period in seconds before scaling in"
  type        = number
  default     = 60
}

variable "autoscaling_scale_out_cooldown" {
  description = "Cooldown period in seconds before scaling out"
  type        = number
  default     = 60
}

# Encryption
variable "use_customer_managed_key" {
  description = "Whether to use a customer managed KMS key for encryption"
  type        = bool
  default     = false
}

# Recovery
variable "point_in_time_recovery_enabled" {
  description = "Whether point-in-time recovery is enabled"
  type        = bool
  default     = true
}

# Streams
variable "stream_enabled" {
  description = "Whether DynamoDB Streams is enabled"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Type of information to write to the stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

# Global tables
variable "replica_regions" {
  description = "List of regions where replicas should be created for global tables"
  type        = list(string)
  default     = []
}
