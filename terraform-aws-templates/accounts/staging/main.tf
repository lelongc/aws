terraform {
  required_version = ">= 1.0.0"
  
  # This backend configuration will be filled in based on environment
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "staging"
      ManagedBy   = "Terraform"
    }
  }
}

# Import global resources
module "iam" {
  source = "../../global/iam"
  
  environment = "staging"
  admin_users = ["staging-admin1"]
  developer_users = ["staging-dev1", "staging-dev2", "staging-dev3"]
}

module "s3" {
  source = "../../global/s3"
  
  environment = "staging"
  project     = var.project
}

module "route53" {
  source = "../../global/route53"
  
  domain_name = var.domain_name
  environment = "staging"
}

module "cloudtrail" {
  source = "../../global/cloudtrail"
  
  environment = "staging"
  project     = var.project
}

# Import regional resources for us-east-1
module "us_east_1" {
  source = "../../regions/us-east-1"
  
  environment = "staging"
  project     = var.project
  owner       = var.owner
  
  vpc_cidr_block = "10.2.0.0/16"
  enable_nat_gateway = true
  key_name = "staging-key"
  db_name = "staging_db"
  log_bucket = "${var.project}-staging-logs"
  
  # Import other variables as needed
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
}

variable "owner" {
  description = "Owner tag for all resources"
  type        = string
  default     = "DevOps"
}
