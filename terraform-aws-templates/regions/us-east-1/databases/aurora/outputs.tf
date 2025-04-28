output "cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "The ARN of the Aurora cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_port" {
  description = "The port used by the cluster"
  value       = aws_rds_cluster.this.port
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.this.database_name
}

output "master_username" {
  description = "The master username for the database"
  value       = aws_rds_cluster.this.master_username
}

output "secret_arn" {
  description = "The ARN of the secret containing database credentials"
  value       = aws_secretsmanager_secret.aurora.arn
}

output "cluster_instances" {
  description = "List of instance identifiers"
  value       = aws_rds_cluster_instance.this.*.identifier
}

output "cluster_instance_endpoints" {
  description = "List of instance endpoints"
  value       = aws_rds_cluster_instance.this.*.endpoint
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = aws_db_subnet_group.this.name
}

output "cluster_parameter_group_name" {
  description = "Name of the cluster parameter group"
  value       = aws_rds_cluster_parameter_group.this.name
}

output "db_parameter_group_name" {
  description = "Name of the DB parameter group"
  value       = aws_db_parameter_group.this.name
}
