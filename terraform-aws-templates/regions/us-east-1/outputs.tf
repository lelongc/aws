# Network Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.security_groups.web_security_group_id
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = module.security_groups.app_security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.security_groups.db_security_group_id
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = module.security_groups.bastion_security_group_id
}

output "elb_security_group_id" {
  description = "ID of the ELB security group"
  value       = module.security_groups.elb_security_group_id
}

# EC2 Instance Outputs
output "web_instance_ids" {
  description = "IDs of web server instances"
  value       = module.ec2_instances.web_instance_ids
}

output "app_instance_ids" {
  description = "IDs of app server instances"
  value       = module.ec2_instances.app_instance_ids
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.ec2_instances.bastion_public_ip
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.load_balancers.alb_dns_name
}

output "alb_zone_id" {
  description = "Route 53 zone ID of the ALB"
  value       = module.load_balancers.alb_zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.load_balancers.target_group_arn
}

# Database Outputs
output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = var.create_database ? module.rds[0].db_instance_endpoint : null
}

output "db_secret_arn" {
  description = "ARN of the secret containing the DB credentials"
  value       = var.create_database ? module.rds[0].db_secret_arn : null
}
