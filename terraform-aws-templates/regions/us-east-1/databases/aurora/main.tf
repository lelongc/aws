provider "aws" {
  region = var.region
}

# Random password for the database
resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store password in Secrets Manager
resource "aws_secretsmanager_secret" "aurora" {
  name        = "${var.project}/${var.environment}/aurora/master-password"
  description = "Master password for Aurora cluster ${var.project}-${var.environment}"
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_secretsmanager_secret_version" "aurora" {
  secret_id     = aws_secretsmanager_secret.aurora.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.master.result
    engine   = var.engine
    host     = aws_rds_cluster.this.endpoint
    port     = aws_rds_cluster.this.port
    dbname   = var.database_name
  })
}

# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name        = "${var.project}-${var.environment}-aurora-subnet-group"
  description = "Aurora subnet group for ${var.project}-${var.environment}"
  subnet_ids  = var.subnet_ids
  
  tags = {
    Name        = "${var.project}-${var.environment}-aurora-subnet-group"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Parameter Group
resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.project}-${var.environment}-cluster-params"
  family      = var.db_parameter_group_family
  description = "Aurora cluster parameter group for ${var.project}-${var.environment}"
  
  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = contains(["rds.force_ssl"], parameter.key) ? "pending-reboot" : "immediate"
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-cluster-params"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.project}-${var.environment}-instance-params"
  family      = var.db_parameter_group_family
  description = "Aurora instance parameter group for ${var.project}-${var.environment}"
  
  dynamic "parameter" {
    for_each = var.instance_parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = contains(["connect_timeout"], parameter.key) ? "pending-reboot" : "immediate"
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-instance-params"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.project}-${var.environment}"
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = random_password.master.result
  port                            = var.port
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = var.security_group_ids
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_id
  
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = "${var.project}-${var.environment}-final-snapshot"
  deletion_protection             = var.deletion_protection
  
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  apply_immediately               = var.apply_immediately
  
  tags = {
    Name        = "${var.project}-${var.environment}-cluster"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
  
  lifecycle {
    ignore_changes = [master_password]
  }
}

# Aurora Cluster Instances
resource "aws_rds_cluster_instance" "this" {
  count                      = var.instance_count
  identifier                 = "${var.project}-${var.environment}-instance-${count.index + 1}"
  cluster_identifier         = aws_rds_cluster.this.id
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  db_parameter_group_name    = aws_db_parameter_group.this.name
  
  publicly_accessible        = var.publicly_accessible
  db_subnet_group_name       = aws_db_subnet_group.this.name
  
  monitoring_interval        = var.monitoring_interval
  monitoring_role_arn        = var.create_monitoring_role ? aws_iam_role.rds_enhanced_monitoring[0].arn : var.monitoring_role_arn
  
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  tags = {
    Name        = "${var.project}-${var.environment}-instance-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Enhanced Monitoring IAM Role
resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name = "${var.project}-${var.environment}-rds-monitoring-role"
  path = "/"

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

  tags = {
    Name        = "${var.project}-${var.environment}-rds-monitoring-role"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.create_monitoring_role ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
