provider "aws" {
  region = var.region
}

# Elasticache Subnet Group (if not provided)
resource "aws_elasticache_subnet_group" "this" {
  count       = var.subnet_group_name == "" ? 1 : 0
  name        = "${var.project}-${var.environment}-cache-subnet"
  description = "ElastiCache subnet group for ${var.project}-${var.environment}"
  subnet_ids  = var.subnet_ids
}

# Elasticache Parameter Group
resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.project}-${var.environment}-${var.engine}-params"
  family      = var.parameter_group_family
  description = "ElastiCache parameter group for ${var.project}-${var.environment}"
  
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

# Security Group for ElastiCache
resource "aws_security_group" "elasticache" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.project}-${var.environment}-elasticache-sg"
  description = "Security group for ElastiCache ${var.engine} cluster"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = var.engine == "redis" ? 6379 : 11211
    to_port         = var.engine == "redis" ? 6379 : 11211
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-elasticache-sg"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_cluster" "this" {
  count                = var.create_cluster && var.replication_group_id == "" ? 1 : 0
  cluster_id           = "${var.project}-${var.environment}-cache"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.this.name
  engine_version       = var.engine_version
  port                 = var.port
  
  subnet_group_name    = var.subnet_group_name != "" ? var.subnet_group_name : aws_elasticache_subnet_group.this[0].name
  security_group_ids   = var.create_security_group ? [aws_security_group.elasticache[0].id] : var.security_group_ids
  
  maintenance_window   = var.maintenance_window
  snapshot_window      = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit
  
  apply_immediately    = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  tags = {
    Name        = "${var.project}-${var.environment}-cache"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# ElastiCache Redis Replication Group (for Redis cluster mode)
resource "aws_elasticache_replication_group" "this" {
  count                      = var.create_cluster && var.engine == "redis" && var.cluster_mode_enabled ? 1 : 0
  replication_group_id       = "${var.project}-${var.environment}-redis"
  description                = "Redis replication group for ${var.project}-${var.environment}"
  node_type                  = var.node_type
  port                       = var.port
  parameter_group_name       = aws_elasticache_parameter_group.this.name
  engine_version             = var.engine_version
  
  subnet_group_name          = var.subnet_group_name != "" ? var.subnet_group_name : aws_elasticache_subnet_group.this[0].name
  security_group_ids         = var.create_security_group ? [aws_security_group.elasticache[0].id] : var.security_group_ids
  
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  tags = {
    Name        = "${var.project}-${var.environment}-redis"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
