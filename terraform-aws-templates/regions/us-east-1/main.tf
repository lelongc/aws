# Main Terraform file for US-East-1 region
# This file orchestrates the modules for this region

# Network Resources
module "vpc" {
  source = "./network/vpc"

  environment = var.environment
  project     = var.project
  vpc_cidr_block = var.vpc_cidr_block
  enable_nat_gateway = var.enable_nat_gateway
  availability_zones = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source = "./network/security-groups"

  environment = var.environment
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  web_ingress_cidr_blocks = var.web_ingress_cidr_blocks
  bastion_ingress_cidr_blocks = var.bastion_ingress_cidr_blocks
  app_port = var.app_port
}

# Compute Resources
module "ec2_instances" {
  source = "./compute/ec2"

  environment = var.environment
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  web_security_group_id = module.security_groups.web_security_group_id
  app_security_group_id = module.security_groups.app_security_group_id
  bastion_security_group_id = module.security_groups.bastion_security_group_id
  key_name = var.key_name
  
  web_instance_count = var.web_instance_count
  app_instance_count = var.app_instance_count
  enable_bastion = var.enable_bastion
}

# Load Balancers
module "load_balancers" {
  source = "./compute/load-balancers"

  environment = var.environment
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  elb_security_group_id = module.security_groups.elb_security_group_id
  log_bucket = var.log_bucket
  enable_https = var.enable_https
  certificate_arn = var.certificate_arn
  target_port = var.app_port
  health_check_path = var.health_check_path
}

# Database
module "rds" {
  count = var.create_database ? 1 : 0
  
  source = "./databases/rds"

  environment = var.environment
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id
  
  engine = var.db_engine
  engine_version = var.db_engine_version
  major_engine_version = var.db_major_engine_version
  parameter_group_family = var.db_parameter_group_family
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  multi_az = var.db_multi_az
  db_name = var.db_name
  db_username = var.db_username
  backup_retention_period = var.db_backup_retention_period
  deletion_protection = var.db_deletion_protection
}
