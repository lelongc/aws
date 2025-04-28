output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private.*.id
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = aws_subnet.database.*.id
}

output "public_subnets_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public.*.cidr_block
}

output "private_subnets_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "database_subnets_cidr_blocks" {
  description = "CIDR blocks of the database subnets"
  value       = aws_subnet.database.*.cidr_block
}

output "db_subnet_group_id" {
  description = "ID of the database subnet group"
  value       = length(aws_db_subnet_group.database) > 0 ? aws_db_subnet_group.database[0].id : null
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = length(aws_db_subnet_group.database) > 0 ? aws_db_subnet_group.database[0].name : null
}

output "elasticache_subnet_group_name" {
  description = "Name of the elasticache subnet group"
  value       = length(aws_elasticache_subnet_group.elasticache) > 0 ? aws_elasticache_subnet_group.elasticache[0].name : null
}
