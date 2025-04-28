provider "aws" {
  region = var.region
}

# DynamoDB Table
resource "aws_dynamodb_table" "this" {
  for_each = { for table in var.tables : table.name => table }
  
  name           = "${var.project}-${var.environment}-${each.value.name}"
  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.billing_mode == "PROVISIONED" ? each.value.read_capacity : null
  write_capacity = each.value.billing_mode == "PROVISIONED" ? each.value.write_capacity : null
  hash_key       = each.value.hash_key
  range_key      = each.value.range_key
  
  # Attributes
  dynamic "attribute" {
    for_each = each.value.attributes
    
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
  
  # GSI
  dynamic "global_secondary_index" {
    for_each = each.value.global_secondary_indexes != null ? each.value.global_secondary_indexes : []
    
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = each.value.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
      read_capacity      = each.value.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
    }
  }
  
  # LSI
  dynamic "local_secondary_index" {
    for_each = each.value.local_secondary_indexes != null ? each.value.local_secondary_indexes : []
    
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.projection_type == "INCLUDE" ? local_secondary_index.value.non_key_attributes : null
    }
  }
  
  # TTL
  dynamic "ttl" {
    for_each = each.value.ttl_attribute != null ? [1] : []
    
    content {
      attribute_name = each.value.ttl_attribute
      enabled        = true
    }
  }
  
  # Point-in-time recovery
  point_in_time_recovery {
    enabled = each.value.point_in_time_recovery
  }
  
  # Server-side encryption
  server_side_encryption {
    enabled     = each.value.server_side_encryption
    kms_key_arn = each.value.kms_key_arn
  }
  
  # Auto scaling (if enabled)
  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    each.value.tags
  )
}

# Auto Scaling for read capacity
resource "aws_appautoscaling_target" "read" {
  for_each = { for table in var.tables : table.name => table if table.billing_mode == "PROVISIONED" && table.autoscaling_read }
  
  max_capacity       = each.value.autoscaling_read_max
  min_capacity       = each.value.autoscaling_read_min
  resource_id        = "table/${aws_dynamodb_table.this[each.key].name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read" {
  for_each = { for table in var.tables : table.name => table if table.billing_mode == "PROVISIONED" && table.autoscaling_read }
  
  name               = "${aws_dynamodb_table.this[each.key].name}-read-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read[each.key].service_namespace
  
  target_tracking_scaling_policy_configuration {
    target_value       = each.value.autoscaling_read_target
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

# Auto Scaling for write capacity
resource "aws_appautoscaling_target" "write" {
  for_each = { for table in var.tables : table.name => table if table.billing_mode == "PROVISIONED" && table.autoscaling_write }
  
  max_capacity       = each.value.autoscaling_write_max
  min_capacity       = each.value.autoscaling_write_min
  resource_id        = "table/${aws_dynamodb_table.this[each.key].name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write" {
  for_each = { for table in var.tables : table.name => table if table.billing_mode == "PROVISIONED" && table.autoscaling_write }
  
  name               = "${aws_dynamodb_table.this[each.key].name}-write-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write[each.key].service_namespace
  
  target_tracking_scaling_policy_configuration {
    target_value       = each.value.autoscaling_write_target
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}
