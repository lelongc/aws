variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "main"
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

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "app_port" {
  description = "Port for application tier"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Port for database tier"
  type        = number
  default     = 3306
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
