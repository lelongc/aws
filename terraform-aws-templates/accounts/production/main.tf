terraform {
  required_version = ">= 1.0.0"
  
  # This backend configuration will be filled in based on environment
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "Terraform"
    }
  }
}

# Import global resources
module "iam" {
  source = "../../global/iam"
  
  environment = "production"
  admin_users = ["prod-admin1", "prod-admin2"]
  developer_users = ["prod-dev1", "prod-dev2"]
}

module "s3" {
  source = "../../global/s3"
  
  environment = "production"
  project     = var.project
}

module "route53" {
  source = "../../global/route53"
  
  domain_name = var.domain_name
  environment = "production"
}

module "cloudtrail" {
  source = "../../global/cloudtrail"
  
  environment = "production"
  project     = var.project
}

# Import regional resources for us-east-1
module "us_east_1" {
  source = "../../regions/us-east-1"
  
  environment = "production"
  project     = var.project
  owner       = var.owner
  
  vpc_cidr_block = "10.1.0.0/16"
  enable_nat_gateway = true
  
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
