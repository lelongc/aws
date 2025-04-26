variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "web"
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

variable "ami_id" {
  description = "AMI ID for instances (if not specified, latest Amazon Linux will be used)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "health_check_type" {
  description = "Health check type for ASG (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "target_group_arns" {
  description = "List of target group ARNs for ASG attachment"
  type        = list(string)
  default     = []
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of root volume"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt root volume"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for root volume encryption"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "additional_iam_policies" {
  description = "List of additional IAM policy ARNs to attach"
  type        = list(string)
  default     = []
}
