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

variable "web_ingress_cidr_blocks" {
  description = "CIDR blocks that can access web servers"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_ingress_cidr_blocks" {
  description = "CIDR blocks that can SSH into the bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}
