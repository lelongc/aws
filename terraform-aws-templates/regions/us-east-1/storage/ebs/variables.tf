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

variable "create_kms_key" {
  description = "Whether to create a KMS key for EBS volume encryption"
  type        = bool
  default     = false
}

variable "volumes" {
  description = "List of EBS volumes to create"
  type = list(object({
    name              = string
    availability_zone = string
    size              = number
    type              = string
    iops              = optional(number)
    throughput        = optional(number)
    kms_key_id        = optional(string)
    snapshot_id       = optional(string)
    instance_id       = optional(string)
    device_name       = optional(string)
    tags              = optional(map(string), {})
  }))
  default = []
}

variable "enable_snapshot_lifecycle" {
  description = "Whether to enable DLM snapshot lifecycle policy"
  type        = bool
  default     = false
}

variable "dlm_role_arn" {
  description = "IAM role ARN for AWS Data Lifecycle Manager"
  type        = string
  default     = null
}

variable "snapshot_interval" {
  description = "Interval between snapshots in hours (12 or 24)"
  type        = number
  default     = 24
}

variable "snapshot_time" {
  description = "Time when snapshots are taken (UTC format)"
  type        = string
  default     = "03:00"
}

variable "snapshot_retention_count" {
  description = "Number of snapshots to retain"
  type        = number
  default     = 7
}
