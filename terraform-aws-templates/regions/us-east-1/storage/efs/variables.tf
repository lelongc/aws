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

variable "vpc_id" {
  description = "ID of the VPC where EFS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where EFS mount targets will be created"
  type        = list(string)
}

variable "create_security_group" {
  description = "Whether to create a security group for EFS"
  type        = bool
  default     = true
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access the EFS"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for EFS mount targets (if not creating a new one)"
  type        = list(string)
  default     = []
}

variable "performance_mode" {
  description = "EFS performance mode (generalPurpose or maxIO)"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "EFS throughput mode (bursting, provisioned, or elastic)"
  type        = string
  default     = "bursting"
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, in MiB/s, that you want to provision for the file system"
  type        = number
  default     = null
}

variable "create_kms_key" {
  description = "Whether to create a KMS key for EFS encryption"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN of the KMS key for EFS encryption if not creating a new one"
  type        = string
  default     = null
}

variable "transition_to_ia" {
  description = "Lifecycle policy for transitioning files to IA storage class (AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, or AFTER_90_DAYS)"
  type        = string
  default     = null
}

variable "transition_to_primary_storage_class" {
  description = "Lifecycle policy for transitioning files back to primary storage class (AFTER_1_ACCESS)"
  type        = string
  default     = null
}

variable "enable_backup" {
  description = "Whether to enable automatic backups using AWS Backup"
  type        = bool
  default     = true
}

variable "access_points" {
  description = "List of access points to create"
  type = list(object({
    name = string
    posix_user = object({
      gid = number
      uid = number
    })
    root_directory = object({
      path = string
      creation_info = object({
        owner_gid   = number
        owner_uid   = number
        permissions = string
      })
    })
  }))
  default = []
}
