module "networking" {
  source      = "../../modules/networking"
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  environment = var.environment
  project_name = "${var.company_name}-finance"
}

resource "aws_security_group" "app" {
  name        = "${var.company_name}-app-sg"
  description = "Security group for finance applications"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name        = "${var.company_name}-db-sg"
  description = "Security group for finance databases"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.company_name}-db-subnet"
  subnet_ids = module.networking.private_subnet_ids
}

resource "aws_db_instance" "transactions" {
  allocated_storage    = 100
  storage_type         = "io1"
  iops                 = 1000
  db_name              = "transactions"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.r5.large"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres15"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  storage_encrypted   = true
  multi_az            = true
  backup_retention_period = 30
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.company_name}-final-snapshot"
  
  tags = {
    Name = "${var.company_name}-transactions-db"
  }
}

resource "aws_kms_key" "app" {
  description             = "KMS key for application encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_wafv2_web_acl" "main" {
  name        = "${var.company_name}-waf"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAFWebACL"
    sampled_requests_enabled   = true
  }
}
