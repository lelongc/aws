output "elasticache_cluster_id" {
  description = "ID of the ElastiCache cluster"
  value       = var.create_cluster && var.replication_group_id == "" ? aws_elasticache_cluster.this[0].id : null
}

output "elasticache_cluster_address" {
  description = "DNS name of the ElastiCache cluster"
  value       = var.create_cluster && var.replication_group_id == "" ? aws_elasticache_cluster.this[0].cache_nodes[0].address : null
}

output "elasticache_cluster_port" {
  description = "Port of the ElastiCache cluster"
  value       = var.create_cluster && var.replication_group_id == "" ? var.port : null
}

output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = var.create_cluster && var.engine == "redis" && var.cluster_mode_enabled ? aws_elasticache_replication_group.this[0].id : null
}

output "replication_group_primary_endpoint" {
  description = "Primary endpoint of the ElastiCache replication group"
  value       = var.create_cluster && var.engine == "redis" && var.cluster_mode_enabled ? aws_elasticache_replication_group.this[0].primary_endpoint_address : null
}

output "replication_group_reader_endpoint" {
  description = "Reader endpoint of the ElastiCache replication group"
  value       = var.create_cluster && var.engine == "redis" && var.cluster_mode_enabled ? aws_elasticache_replication_group.this[0].reader_endpoint_address : null
}

output "parameter_group_name" {
  description = "Name of the parameter group used"
  value       = aws_elasticache_parameter_group.this.name
}

output "subnet_group_name" {
  description = "Name of the subnet group used"
  value       = var.subnet_group_name != "" ? var.subnet_group_name : (length(aws_elasticache_subnet_group.this) > 0 ? aws_elasticache_subnet_group.this[0].name : null)
}

output "security_group_id" {
  description = "ID of the security group created for ElastiCache"
  value       = var.create_security_group ? aws_security_group.elasticache[0].id : null
}
