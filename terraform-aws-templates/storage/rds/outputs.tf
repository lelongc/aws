output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.this.db_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.this.username
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.this.id
}

output "db_parameter_group_id" {
  description = "The db parameter group name"
  value       = aws_db_parameter_group.this.id
}

output "db_option_group_id" {
  description = "The db option group name"
  value       = var.engine == "mysql" || var.engine == "mariadb" || var.engine == "oracle-ee" || var.engine == "oracle-se2" ? aws_db_option_group.this[0].id : null
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = aws_db_instance.this.resource_id
}

output "db_master_password" {
  description = "The master password (only available if not deleted from state)"
  value       = var.password != null ? var.password : random_password.master[0].result
  sensitive   = true
}

output "kms_key_id" {
  description = "The ARN of the KMS key used for encryption"
  value       = var.create_kms_key ? aws_kms_key.db[0].arn : var.kms_key_id
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The ARN of the monitoring role"
  value       = var.create_monitoring_role ? aws_iam_role.rds_enhanced_monitoring[0].arn : var.monitoring_role_arn
}

output "ssm_parameter_db_password" {
  description = "The SSM parameter name for database password"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.db_password[0].name : null
}

output "ssm_parameter_db_username" {
  description = "The SSM parameter name for database username"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.db_username[0].name : null
}

output "ssm_parameter_db_endpoint" {
  description = "The SSM parameter name for database endpoint"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.db_endpoint[0].name : null
}
