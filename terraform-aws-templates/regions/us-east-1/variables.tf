# General Variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "owner" {
  description = "Owner of the resource, used in tags"
  type        = string
  default     = "DevOps"
}

# Network Variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway for private subnets"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
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

# EC2 Variables
variable "key_name" {
  description = "Name of the SSH key pair to use"
  type        = string
}

variable "web_instance_count" {
  description = "Number of web server instances to launch"
  type        = number
  default     = 2
}

variable "app_instance_count" {
  description = "Number of app server instances to launch"
  type        = number
  default     = 2
}

variable "enable_bastion" {
  description = "Whether to create a bastion host"
  type        = bool
  default     = false
}

# Load Balancer Variables
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

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/health"
}

# Database Variables
variable "create_database" {
  description = "Whether to create a database"
  type        = bool
  default     = true
}

variable "db_engine" {
  description = "Database engine type (mysql, postgres, etc.)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_major_engine_version" {
  description = "Major version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Amount of storage to allocate (GB)"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum storage limit for autoscaling (GB)"
  type        = number
  default     = 100
}

variable "db_multi_az" {
  description = "Use Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "db_backup_retention_period" {
  description = "Number of days to keep backups"
  type        = number
  default     = 7
}

variable "db_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}
