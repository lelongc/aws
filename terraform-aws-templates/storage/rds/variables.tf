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

# DB Instance
variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type: standard, gp2, gp3, or io1"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "ARN for the KMS encryption key if storage_encrypted is true"
  type        = string
  default     = null
}

variable "create_kms_key" {
  description = "Create a new KMS key for RDS encryption"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine: mysql, postgres, oracle-ee, oracle-se2, mariadb, etc."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "major_engine_version" {
  description = "Major engine version for option group"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Database instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the master DB user (if not provided, a random password will be generated)"
  type        = string
  default     = null
  sensitive   = true
}

# Networking
variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Specifies if the RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null # Will use default port for the engine
}

# Backups and maintenance
variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00" # UTC
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "sun:04:00-sun:05:00" # UTC
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

# Parameter and option groups
variable "parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "mysql8.0"
}

variable "parameters" {
  description = "List of DB parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "options" {
  description = "List of DB options to apply (for engines that support them)"
  type = list(object({
    option_name     = string
    option_settings = list(map(string))
  }))
  default = []
}

# Monitoring and insights
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected (0 disables)"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that allows RDS to send metrics to CloudWatch"
  type        = string
  default     = null
}

variable "create_monitoring_role" {
  description = "Create IAM role for RDS enhanced monitoring"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The retention period for Performance Insights, in days"
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs"
  type        = list(string)
  default     = []
}

# Misc settings
variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any DB modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "create_ssm_parameters" {
  description = "Create SSM parameters for database credentials"
  type        = bool
  default     = false
}
