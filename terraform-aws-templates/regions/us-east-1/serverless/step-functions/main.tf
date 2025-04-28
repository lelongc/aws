provider "aws" {
  region = var.region
}

# IAM Role for Step Functions
resource "aws_iam_role" "step_function" {
  name = "${var.project}-${var.environment}-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project}-${var.environment}-sfn-role"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# IAM Policy for Step Functions
resource "aws_iam_policy" "step_function" {
  name        = "${var.project}-${var.environment}-sfn-policy"
  description = "Policy for Step Functions state machine"

  policy = var.step_function_policy != null ? var.step_function_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = var.lambda_arns
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
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
resource "aws_iam_role_policy_attachment" "step_function" {
  role       = aws_iam_role.step_function.name
  policy_arn = aws_iam_policy.step_function.arn
}

# CloudWatch Log Group for Step Functions
resource "aws_cloudwatch_log_group" "step_function" {
  name              = "/aws/states/${var.project}-${var.environment}-sfn"
  retention_in_days = var.log_retention_days
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Step Functions State Machine
resource "aws_sfn_state_machine" "this" {
  name     = "${var.project}-${var.environment}-sfn"
  role_arn = aws_iam_role.step_function.arn
  
  definition = var.state_machine_definition
  
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.step_function.arn}:*"
    include_execution_data = var.include_execution_data
    level                  = var.logging_level
  }
  
  tracing_configuration {
    enabled = var.tracing_enabled
  }
  
  type = var.step_function_type
  
  tags = {
    Name        = "${var.project}-${var.environment}-sfn"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# CloudWatch Event Rule for Step Functions (if needed)
resource "aws_cloudwatch_event_rule" "step_function" {
  count = var.enable_event_trigger ? 1 : 0
  
  name        = "${var.project}-${var.environment}-sfn-rule"
  description = "Trigger Step Functions workflow"
  
  schedule_expression = var.event_schedule_expression
  event_pattern       = var.event_pattern
  state               = "ENABLED"
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "step_function" {
  count = var.enable_event_trigger ? 1 : 0
  
  rule      = aws_cloudwatch_event_rule.step_function[0].name
  target_id = "StepFunctionTarget"
  arn       = aws_sfn_state_machine.this.arn
  role_arn  = var.event_role_arn
  
  # Input transformer if needed
  dynamic "input_transformer" {
    for_each = var.event_input_transformer != null ? [var.event_input_transformer] : []
    content {
      input_paths    = input_transformer.value.input_paths
      input_template = input_transformer.value.input_template
    }
  }
}
