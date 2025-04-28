terraform {
  required_version = ">= 1.0.0"
  
  # This backend configuration will be filled in based on environment
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "development"
      ManagedBy   = "Terraform"
    }
  }
}

# Import global resources
module "iam" {
  source = "../../global/iam"
  
  environment = "development"
  admin_users = ["dev-admin1"]
  developer_users = ["dev-dev1", "dev-dev2", "dev-dev3", "dev-dev4"]
}

module "s3" {
  source = "../../global/s3"
  
  environment = "development"
  project     = var.project
}

module "route53" {
  source = "../../global/route53"
  
  domain_name = var.domain_name
  environment = "development"
}

module "cloudtrail" {
  source = "../../global/cloudtrail"
  
  environment = "development"
  project     = var.project
}

# Import regional resources for us-east-1
module "us_east_1" {
  source = "../../regions/us-east-1"
  
  environment = "development"
  project     = var.project
  owner       = var.owner
  
  vpc_cidr_block = "10.3.0.0/16"
  enable_nat_gateway = true
  
  db_name      = "${var.project}-development"
  key_name     = "development-key"
  log_bucket   = module.s3.log_bucket_id
  
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
