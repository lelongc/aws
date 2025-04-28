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
  default     = "my-project"
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "create_root_zone" {
  description = "Whether to create the root zone"
  type        = bool
  default     = false
}

variable "create_env_zone" {
  description = "Whether to create environment subdomain zone"
  type        = bool
  default     = true
}

variable "create_api_record" {
  description = "Whether to create API record"
  type        = bool
  default     = true
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
  default     = ""
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
  default     = ""
}

variable "api_dns_name" {
  description = "DNS name of the API endpoint"
  type        = string
  default     = ""
}

variable "api_zone_id" {
  description = "Zone ID of the API endpoint"
  type        = string
  default     = ""
}
