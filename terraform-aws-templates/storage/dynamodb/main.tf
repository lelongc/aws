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

# KMS key for DynamoDB encryption if specified
resource "aws_kms_key" "dynamodb" {
  count = var.use_customer_managed_key ? 1 : 0
  
  description             = "KMS key for DynamoDB table ${local.name}-${local.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  tags = local.tags
}

resource "aws_kms_alias" "dynamodb" {
  count = var.use_customer_managed_key ? 1 : 0
  
  name          = "alias/${local.name}-${local.environment}-dynamodb-key"
  target_key_id = aws_kms_key.dynamodb[0].key_id
}

# DynamoDB Table
resource "aws_dynamodb_table" "this" {
  name = "${local.name}-${local.environment}"
  
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  
  hash_key  = var.hash_key
  range_key = var.range_key
  
  # Attributes
  dynamic "attribute" {
    for_each = var.attributes
    
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
  
  # TTL
  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    
    content {
      enabled        = true
      attribute_name = var.ttl_attribute_name
    }
  }
  
  # Global Secondary Indexes
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      
      read_capacity  = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "read_capacity", var.gsi_read_capacity) : null
      write_capacity = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "write_capacity", var.gsi_write_capacity) : null
    }
  }
  
  # Local Secondary Indexes
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }
  
  # Point-in-time recovery
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }
  
  # Server-side encryption
  server_side_encryption {
    enabled     = true
    kms_key_arn = var.use_customer_managed_key ? aws_kms_key.dynamodb[0].arn : null
  }
  
  # Stream configuration
  dynamic "stream_enabled" {
    for_each = var.stream_enabled ? [1] : []
    
    content {
      stream_enabled  = true
      stream_view_type = var.stream_view_type
    }
  }
  
  # Auto scaling configuration for provisioned tables
  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
  
  tags = local.tags
}

# Auto scaling for read capacity
resource "aws_appautoscaling_target" "read_target" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0
  
  max_capacity       = var.read_capacity_max
  min_capacity       = var.read_capacity
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0
  
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target[0].service_namespace
  
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    
    target_value       = var.autoscaling_read_target
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}

# Auto scaling for write capacity
resource "aws_appautoscaling_target" "write_target" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0
  
  max_capacity       = var.write_capacity_max
  min_capacity       = var.write_capacity
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0
  
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target[0].service_namespace
  
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    
    target_value       = var.autoscaling_write_target
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}

# DynamoDB global tables (Version 2019.11.21)
resource "aws_dynamodb_table_replica" "replica" {
  for_each = toset(var.replica_regions)
  
  global_table_arn  = aws_dynamodb_table.this.arn
  provider          = aws.replica
  kms_key_arn       = var.use_customer_managed_key ? aws_kms_key.dynamodb_replica[each.key].arn : null
  
  depends_on = [aws_kms_key.dynamodb_replica]
}

# KMS keys for replicas if using customer managed keys
resource "aws_kms_key" "dynamodb_replica" {
  for_each = var.use_customer_managed_key ? toset(var.replica_regions) : []
  
  provider                = aws.replica
  description             = "KMS key for DynamoDB table ${local.name}-${local.environment} in ${each.key}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  tags = local.tags
}

resource "aws_kms_alias" "dynamodb_replica" {
  for_each = var.use_customer_managed_key ? toset(var.replica_regions) : []
  
  provider      = aws.replica
  name          = "alias/${local.name}-${local.environment}-dynamodb-key-${each.key}"
  target_key_id = aws_kms_key.dynamodb_replica[each.key].key_id
}
