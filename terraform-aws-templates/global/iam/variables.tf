variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "admin_users" {
  description = "List of admin IAM users to create"
  type        = list(string)
  default     = []
}

variable "developer_users" {
  description = "List of developer IAM users to create"
  type        = list(string)
  default     = []
}
