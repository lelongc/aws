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
  description = "ID of the VPC"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for NAT Gateway"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "ID of the internet gateway"
  type        = string
}
