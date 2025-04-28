variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID for the app"
  type        = string
}

variable "auto_scaling_group_arn" {
  description = "ARN of the auto scaling group for ECS capacity provider"
  type        = string
}

variable "app_target_group_arn" {
  description = "ARN of the target group for the app"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "app_container_image" {
  description = "Container image for the app"
  type        = string
}

variable "app_container_port" {
  description = "Container port for the app"
  type        = number
  default     = 8080
}

variable "app_task_cpu" {
  description = "CPU units for the app task"
  type        = number
  default     = 256
}

variable "app_task_memory" {
  description = "Memory for the app task in MB"
  type        = number
  default     = 512
}

variable "app_desired_count" {
  description = "Desired count of app containers"
  type        = number
  default     = 2
}

variable "app_min_capacity" {
  description = "Minimum capacity for app autoscaling"
  type        = number
  default     = 2
}

variable "app_max_capacity" {
  description = "Maximum capacity for app autoscaling"
  type        = number
  default     = 10
}

variable "app_environment_vars" {
  description = "Environment variables for the app container"
  type        = map(string)
  default     = {}
}
