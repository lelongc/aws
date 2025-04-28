provider "aws" {
  region = var.region
}

# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda" {
  name = "${var.project}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project}-${var.environment}-lambda-role"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Basic Lambda execution policy
resource "aws_iam_policy" "lambda_basic" {
  name        = "${var.project}-${var.environment}-lambda-basic-policy"
  description = "Basic policy for Lambda functions"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_basic.arn
}

# Additional policy attachments
resource "aws_iam_role_policy_attachment" "additional_policies" {
  for_each = toset(var.additional_policy_arns)
  
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

# Lambda Functions
resource "aws_lambda_function" "functions" {
  for_each = { for f in var.functions : f.name => f }
  
  function_name = "${var.project}-${var.environment}-${each.value.name}"
  description   = lookup(each.value, "description", "${each.value.name} function for ${var.project}-${var.environment}")
  
  # Code source
  filename         = lookup(each.value, "filename", null)
  source_code_hash = lookup(each.value, "filename", null) != null ? filebase64sha256(each.value.filename) : null
  s3_bucket        = lookup(each.value, "s3_bucket", null)
  s3_key           = lookup(each.value, "s3_key", null)
  s3_object_version= lookup(each.value, "s3_object_version", null)
  image_uri        = lookup(each.value, "image_uri", null)
  
  role             = lookup(each.value, "role_arn", aws_iam_role.lambda.arn)
  handler          = lookup(each.value, "image_uri", null) == null ? lookup(each.value, "handler", "index.handler") : null
  runtime          = lookup(each.value, "image_uri", null) == null ? lookup(each.value, "runtime", "nodejs18.x") : null
  package_type     = lookup(each.value, "image_uri", null) != null ? "Image" : "Zip"
  
  memory_size      = lookup(each.value, "memory_size", 128)
  timeout          = lookup(each.value, "timeout", 3)
  
  reserved_concurrent_executions = lookup(each.value, "reserved_concurrent_executions", null)
  
  # Environment variables
  dynamic "environment" {
    for_each = lookup(each.value, "environment_variables", null) != null ? [true] : []
    
    content {
      variables = each.value.environment_variables
    }
  }
  
  # VPC Config
  dynamic "vpc_config" {
    for_each = lookup(each.value, "subnet_ids", null) != null && lookup(each.value, "security_group_ids", null) != null ? [true] : []
    
    content {
      subnet_ids         = each.value.subnet_ids
      security_group_ids = each.value.security_group_ids
    }
  }
  
  # Tracing
  tracing_config {
    mode = lookup(each.value, "tracing_mode", "PassThrough")
  }
  
  # Layers
  layers = lookup(each.value, "layers", [])
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    lookup(each.value, "tags", {})
  )
}

# CloudWatch Log Groups for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  for_each = aws_lambda_function.functions
  
  name              = "/aws/lambda/${each.value.function_name}"
  retention_in_days = var.log_retention_days
  
  tags = {
    Name        = "${each.value.function_name}-logs"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Event Source Mappings (optional)
resource "aws_lambda_event_source_mapping" "event_sources" {
  for_each = { 
    for es in var.event_source_mappings : 
    "${es.function_name}-${es.event_source_arn}" => es 
  }
  
  function_name     = aws_lambda_function.functions[each.value.function_name].function_name
  event_source_arn  = each.value.event_source_arn
  
  enabled           = lookup(each.value, "enabled", true)
  batch_size        = lookup(each.value, "batch_size", 10)
  starting_position = lookup(each.value, "starting_position", null)
  
  maximum_batching_window_in_seconds = lookup(each.value, "maximum_batching_window_in_seconds", null)
  parallelization_factor             = lookup(each.value, "parallelization_factor", null)
  maximum_retry_attempts             = lookup(each.value, "maximum_retry_attempts", null)
  
  # DynamoDB specific
  dynamic "destination_config" {
    for_each = lookup(each.value, "on_failure_destination_arn", null) != null ? [true] : []
    
    content {
      on_failure {
        destination_arn = each.value.on_failure_destination_arn
      }
    }
  }
  
  # Filter criteria
  dynamic "filter_criteria" {
    for_each = lookup(each.value, "filter_criteria", null) != null ? [true] : []
    
    content {
      dynamic "filter" {
        for_each = each.value.filter_criteria
        
        content {
          pattern = filter.value
        }
      }
    }
  }
}

# Permission for event sources to invoke functions
resource "aws_lambda_permission" "permissions" {
  for_each = { for p in var.function_permissions : "${p.function_name}-${p.principal}-${p.source_arn}" => p }
  
  function_name = aws_lambda_function.functions[each.value.function_name].function_name
  statement_id  = lookup(each.value, "statement_id", "AllowExecution${title(each.value.principal)}${title(each.value.function_name)}")
  action        = "lambda:InvokeFunction"
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}
