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

variable "enable_shield_advanced" {
  description = "Enable AWS Shield Advanced protection"
  type        = bool
  default     = false
}

variable "alb_arn" {
  description = "ARN of the ALB to protect"
  type        = string
  default     = null
}

variable "cloudfront_arn" {
  description = "ARN of the CloudFront distribution to protect"
  type        = string
  default     = null
}

variable "route53_hosted_zone_id" {
  description = "ID of the Route53 hosted zone to protect"
  type        = string
  default     = null
}

variable "elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP to protect"
  type        = string
  default     = null
}

variable "create_protection_group" {
  description = "Whether to create a protection group"
  type        = bool
  default     = false
}

variable "protection_group_aggregation" {
  description = "Aggregation method for the protection group (SUM, MEAN, MAX)"
  type        = string
  default     = "SUM"
}

variable "protection_group_pattern" {
  description = "Pattern type for the protection group (ALL, ARBITRARY, BY_RESOURCE_TYPE)"
  type        = string
  default     = "ALL"
}

variable "create_ddos_alarm" {
  description = "Whether to create CloudWatch alarms for DDoS attacks"
  type        = bool
  default     = false
}
