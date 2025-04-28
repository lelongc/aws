provider "aws" {
  region = var.region
}

# KMS Key for EBS Volumes if encryption is enabled with custom key
resource "aws_kms_key" "ebs" {
  count = var.create_kms_key ? 1 : 0
  
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  
  tags = {
    Name        = "${var.project}-${var.environment}-ebs-kms-key"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_kms_alias" "ebs" {
  count = var.create_kms_key ? 1 : 0
  
  name          = "alias/${var.project}-${var.environment}-ebs-key"
  target_key_id = aws_kms_key.ebs[0].key_id
}

# EBS Volumes
resource "aws_ebs_volume" "this" {
  for_each = { for volume in var.volumes : volume.name => volume }
  
  availability_zone = each.value.availability_zone
  size              = each.value.size
  type              = each.value.type
  iops              = contains(["io1", "io2", "gp3"], each.value.type) ? each.value.iops : null
  throughput        = each.value.type == "gp3" ? each.value.throughput : null
  
  encrypted  = true
  kms_key_id = var.create_kms_key ? aws_kms_key.ebs[0].arn : each.value.kms_key_id
  
  snapshot_id = each.value.snapshot_id
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.key}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    each.value.tags
  )
}

# Volume Attachments (if EC2 instance IDs are provided)
resource "aws_volume_attachment" "this" {
  for_each = { 
    for volume in var.volumes : 
    volume.name => volume 
    if volume.instance_id != null && volume.device_name != null
  }
  
  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.this[each.key].id
  instance_id = each.value.instance_id
}

# EBS Snapshot Schedule (if enabled)
resource "aws_dlm_lifecycle_policy" "ebs_snapshot_policy" {
  count = var.enable_snapshot_lifecycle ? 1 : 0
  
  description        = "EBS snapshot lifecycle policy for ${var.project}-${var.environment}"
  execution_role_arn = var.dlm_role_arn
  state              = "ENABLED"
  
  policy_details {
    resource_types = ["VOLUME"]
    
    schedule {
      name = "${var.project}-${var.environment}-snapshot-schedule"
      
      create_rule {
        interval      = var.snapshot_interval
        interval_unit = "HOURS"
        times         = [var.snapshot_time]
      }
      
      retain_rule {
        count = var.snapshot_retention_count
      }
      
      copy_tags = true
    }
    
    target_tags = {
      Project     = var.project
      Environment = var.environment
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-dlm-policy"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
