# Production Environment Configuration for us-east-1

# General
environment = "prod"
project     = "my-project"
owner       = "DevOps"

# Network
vpc_cidr_block = "10.1.0.0/16"
enable_nat_gateway = true
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
app_port = 8080

# EC2
key_name = "prod-key-pair"
web_instance_count = 3
app_instance_count = 3
enable_bastion = true

# Load Balancer
log_bucket = "my-project-prod-logs"
enable_https = true
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/prod-cert"
health_check_path = "/health"

# Database
create_database = true
db_engine = "mysql"
db_engine_version = "8.0"
db_major_engine_version = "8.0"
db_parameter_group_family = "mysql8.0"
db_instance_class = "db.t3.large"
db_allocated_storage = 50
db_max_allocated_storage = 200
db_multi_az = true
db_name = "myprojectprod"
db_username = "admin"
db_backup_retention_period = 30
db_deletion_protection = true
