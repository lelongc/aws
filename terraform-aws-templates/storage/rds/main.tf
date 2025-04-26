provider "aws" {
  region = var.region
}

locals {
  name        = var.name
  environment = var.environment
  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# Random password for DB if not provided
resource "random_password" "master" {
  count   = var.password == null ? 1 : 0
  length  = 16
  special = false
}

# KMS key for storage encryption if enabled
resource "aws_kms_key" "db" {
  count               = var.create_kms_key ? 1 : 0
  description         = "KMS key for RDS database encryption"
  enable_key_rotation = true
  tags                = local.tags
}

resource "aws_kms_alias" "db" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${local.name}-db-key-${local.environment}"
  target_key_id = aws_kms_key.db[0].key_id
}

# Parameter group
resource "aws_db_parameter_group" "this" {
  name        = "${local.name}-pg-${local.environment}"
  family      = var.parameter_group_family
  description = "Database parameter group for ${local.name} ${local.environment}"
  
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = local.tags
}

# Option group
resource "aws_db_option_group" "this" {
  count                = var.engine == "mysql" || var.engine == "mariadb" || var.engine == "oracle-ee" || var.engine == "oracle-se2" ? 1 : 0
  name                 = "${local.name}-og-${local.environment}"
  engine_name          = var.engine
  major_engine_version = var.major_engine_version
  
  dynamic "option" {
    for_each = var.options
    content {
      option_name = option.value.option_name
      
      dynamic "option_settings" {
        for_each = option.value.option_settings == null ? [] : option.value.option_settings
        content {
          name  = option_settings.value.name
          value = option_settings.value.value
        }
      }
    }
  }

  tags = local.tags
}

# Subnet group
resource "aws_db_subnet_group" "this" {
  name        = "${local.name}-subnet-group-${local.environment}"
  description = "Database subnet group for ${local.name} ${local.environment}"
  subnet_ids  = var.subnet_ids
  
  tags = local.tags
}

# RDS instance
resource "aws_db_instance" "this" {
  identifier        = "${local.name}-db-${local.environment}"
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_name           = var.db_name
  username          = var.username
  password          = var.password != null ? var.password : random_password.master[0].result
  
  parameter_group_name   = aws_db_parameter_group.this.name
  option_group_name      = var.engine == "mysql" || var.engine == "mariadb" || var.engine == "oracle-ee" || var.engine == "oracle-se2" ? aws_db_option_group.this[0].name : null
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  port                   = var.port
  storage_encrypted      = var.storage_encrypted
  kms_key_id             = var.storage_encrypted && var.create_kms_key ? aws_kms_key.db[0].arn : var.kms_key_id
  
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  copy_tags_to_snapshot     = true
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${local.name}-final-snapshot-${local.environment}"
  deletion_protection       = var.deletion_protection
  
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled && var.create_kms_key ? aws_kms_key.db[0].arn : var.performance_insights_kms_key_id
  
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.create_monitoring_role ? aws_iam_role.rds_enhanced_monitoring[0].arn : var.monitoring_role_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  
  tags = local.tags
}

# Enhanced Monitoring Role
resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0
  name  = "${local.name}-rds-monitoring-role-${local.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  ]

  tags = local.tags
}

# SSM Parameter Store for DB credentials
resource "aws_ssm_parameter" "db_password" {
  count       = var.create_ssm_parameters ? 1 : 0
  name        = "/database/${local.environment}/${local.name}/password"
  description = "Master password for ${local.name} database in ${local.environment}"
  type        = "SecureString"
  value       = var.password != null ? var.password : random_password.master[0].result

  tags = local.tags
}

resource "aws_ssm_parameter" "db_username" {
  count       = var.create_ssm_parameters ? 1 : 0
  name        = "/database/${local.environment}/${local.name}/username"
  description = "Master username for ${local.name} database in ${local.environment}"
  type        = "SecureString"
  value       = var.username

  tags = local.tags
}

resource "aws_ssm_parameter" "db_endpoint" {
  count       = var.create_ssm_parameters ? 1 : 0
  name        = "/database/${local.environment}/${local.name}/endpoint"
  description = "Endpoint for ${local.name} database in ${local.environment}"
  type        = "String"
  value       = aws_db_instance.this.endpoint

  tags = local.tags
}
