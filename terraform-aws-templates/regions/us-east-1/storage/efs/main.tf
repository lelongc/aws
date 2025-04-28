provider "aws" {
  region = var.region
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  count = var.create_security_group ? 1 : 0
  
  name        = "${var.project}-${var.environment}-efs-sg"
  description = "Security group for EFS file system"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-efs-sg"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# KMS Key for EFS if encryption is enabled
resource "aws_kms_key" "efs" {
  count = var.create_kms_key ? 1 : 0
  
  description             = "KMS key for EFS encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  
  tags = {
    Name        = "${var.project}-${var.environment}-efs-kms-key"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_kms_alias" "efs" {
  count = var.create_kms_key ? 1 : 0
  
  name          = "alias/${var.project}-${var.environment}-efs-key"
  target_key_id = aws_kms_key.efs[0].key_id
}

# EFS File System
resource "aws_efs_file_system" "this" {
  creation_token = "${var.project}-${var.environment}-efs"
  
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput_in_mibps : null
  
  encrypted  = true
  kms_key_id = var.create_kms_key ? aws_kms_key.efs[0].arn : var.kms_key_id
  
  # Optional: Lifecycle Policy
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != null ? [1] : []
    content {
      transition_to_ia = var.transition_to_ia
    }
  }
  
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_primary_storage_class != null ? [1] : []
    content {
      transition_to_primary_storage_class = var.transition_to_primary_storage_class
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-efs"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# EFS Backup Policy
resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  
  backup_policy {
    status = var.enable_backup ? "ENABLED" : "DISABLED"
  }
}

# EFS Mount Targets
resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)
  
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = var.create_security_group ? [aws_security_group.efs[0].id] : var.security_group_ids
}

# EFS Access Points
resource "aws_efs_access_point" "this" {
  for_each = { for ap in var.access_points : ap.name => ap }
  
  file_system_id = aws_efs_file_system.this.id
  
  posix_user {
    gid = each.value.posix_user.gid
    uid = each.value.posix_user.uid
  }
  
  root_directory {
    path = each.value.root_directory.path
    
    creation_info {
      owner_gid   = each.value.root_directory.creation_info.owner_gid
      owner_uid   = each.value.root_directory.creation_info.owner_uid
      permissions = each.value.root_directory.creation_info.permissions
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-ap-${each.key}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
