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

# Create IAM role for the Lambda function
resource "aws_iam_role" "lambda" {
  name = "${local.name}-lambda-role-${local.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach additional policies if needed
resource "aws_iam_role_policy_attachment" "lambda_additional" {
  for_each = toset(var.additional_lambda_policies)

  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

# Create custom policy if defined
resource "aws_iam_policy" "lambda_custom" {
  count = length(var.custom_lambda_policy) > 0 ? 1 : 0
  
  name        = "${local.name}-lambda-custom-policy-${local.environment}"
  description = "Custom policy for ${local.name} Lambda"
  
  policy = jsonencode(var.custom_lambda_policy)
  
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "lambda_custom" {
  count = length(var.custom_lambda_policy) > 0 ? 1 : 0
  
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_custom[0].arn
}

# Create Lambda function
resource "aws_lambda_function" "this" {
  function_name    = "${local.name}-${local.environment}"
  description      = var.description
  role             = aws_iam_role.lambda.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  
  timeout     = var.timeout
  memory_size = var.memory_size

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = var.tracing_mode
  }

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }

  tags = local.tags
}

# Add CloudWatch Log Group with retention
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.log_retention_in_days
  
  tags = local.tags
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = "${local.name}-api-${local.environment}"
  description = "API Gateway for ${local.name}"
  
  endpoint_configuration {
    types = [var.api_gateway_endpoint_type]
  }

  tags = local.tags
}

# API Gateway Resource
resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.api_path_part
}

# API Gateway Method
# resource "aws_api_gateway_method" "this" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.this.id
#   http_method   = var.http_method
#   authorization_type = var.authorization_type
  
#   # Add authorizer_id if authorization_type is CUSTOM or COGNITO_USER_POOLS
#   authorizer_id = var.authorization_type == "NONE" ? null : var.authorizer_id
  
#   request_parameters = var.request_parameters
# }

# API Gateway Integration
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  
  # Source ARN format: arn:aws:execute-api:{regionId}:{accountId}:{apiId}/{stage}/{method}/{resourcePath}
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.this.http_method}${aws_api_gateway_resource.this.path}"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.this
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id
  
  # Force a new deployment on config changes
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this.id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_integration.this.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_stage_name
  
  xray_tracing_enabled = var.xray_tracing_enabled

  tags = local.tags
}

# API Gateway Method Settings
resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    data_trace_enabled     = var.api_logging_enabled
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
  }
}
