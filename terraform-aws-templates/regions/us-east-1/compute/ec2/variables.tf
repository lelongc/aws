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

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for bastion host"
  type        = list(string)
  default     = []
}

variable "web_security_group_id" {
  description = "Security group ID for web servers"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for application servers"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security group ID for bastion host"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of the SSH key pair to use"
  type        = string
}

# Web server variables
variable "web_instance_count" {
  description = "Number of web server instances to launch"
  type        = number
  default     = 2
}

variable "web_ami_id" {
  description = "AMI ID for web servers"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2 AMI
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "web_root_volume_size" {
  description = "Root volume size for web servers in GB"
  type        = number
  default     = 20
}

# App server variables
variable "app_instance_count" {
  description = "Number of app server instances to launch"
  type        = number
  default     = 2
}

variable "app_ami_id" {
  description = "AMI ID for app servers"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2 AMI
}

variable "app_instance_type" {
  description = "Instance type for app servers"
  type        = string
  default     = "t3.small"
}

variable "app_root_volume_size" {
  description = "Root volume size for app servers in GB"
  type        = number
  default     = 30
}

# Bastion host variables
variable "enable_bastion" {
  description = "Whether to create a bastion host"
  type        = bool
  default     = false
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion host"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2 AMI
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_root_volume_size" {
  description = "Root volume size for bastion host in GB"
  type        = number
  default     = 10
}
