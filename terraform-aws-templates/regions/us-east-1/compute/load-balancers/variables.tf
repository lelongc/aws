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

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the load balancer"
  type        = list(string)
}

variable "elb_security_group_id" {
  description = "Security group ID for the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
}

variable "enable_https" {
  description = "Whether to enable HTTPS"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "Port for health check"
  type        = string
  default     = "traffic-port"
}

variable "create_nlb" {
  description = "Whether to create a Network Load Balancer"
  type        = bool
  default     = false
}

variable "internal_nlb" {
  description = "Whether the NLB is internal"
  type        = bool
  default     = true
}

variable "nlb_port" {
  description = "Port for NLB listener"
  type        = number
  default     = 80
}

variable "nlb_protocol" {
  description = "Protocol for NLB listener"
  type        = string
  default     = "TCP"
}

variable "nlb_target_port" {
  description = "Port for NLB target group"
  type        = number
  default     = 80
}

variable "nlb_health_check_path" {
  description = "Path for NLB health check"
  type        = string
  default     = "/health"
}

variable "nlb_health_check_port" {
  description = "Port for NLB health check"
  type        = string
  default     = "traffic-port"
}

variable "alarm_actions" {
  description = "List of ARNs for alarm actions"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of ARNs for ok actions"
  type        = list(string)
  default     = []
}
