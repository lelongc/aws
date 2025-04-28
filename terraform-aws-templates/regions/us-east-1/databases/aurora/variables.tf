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

variable "engine" {
  description = "Aurora database engine type: aurora-mysql or aurora-postgresql"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Aurora database engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.03.0"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Aurora DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for Aurora cluster"
  type        = list(string)
}

variable "db_parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "aurora-mysql8.0"
}

variable "cluster_parameters" {
  description = "Map of DB cluster parameters to apply"
  type        = map(string)
  default     = {}
}

variable "instance_parameters" {
  description = "Map of DB instance parameters to apply"
  type        = map(string)
  default     = {}
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-05:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the Aurora cluster"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately or during maintenance window"
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["audit", "error", "general", "slowquery"]
}

variable "instance_count" {
  description = "Number of Aurora instances to create"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance type for Aurora instances"
  type        = string
  default     = "db.t3.medium"
}

variable "publicly_accessible" {
  description = "Whether instances are publicly accessible"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 60
}

variable "create_monitoring_role" {
  description = "Whether to create the IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_role_arn" {
  description = "ARN of an existing IAM role for enhanced monitoring"
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade minor engine versions"
  type        = bool
  default     = true
}
