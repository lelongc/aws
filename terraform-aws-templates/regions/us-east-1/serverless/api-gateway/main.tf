provider "aws" {
  region = var.region
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = "${var.project}-${var.environment}-api"
  description = "${var.api_description} for ${var.project}-${var.environment}"
  
  endpoint_configuration {
    types = [var.endpoint_type]
  }
  
  # API Gateway Policy (optional)
  policy = var.api_policy
  
  # Binary Media Types support (optional)
  binary_media_types = var.binary_media_types
  
  # CORS configuration
  dynamic "cors_configuration" {
    for_each = var.enable_cors ? [true] : []
    content {
      allow_headers = var.cors_allow_headers
      allow_methods = var.cors_allow_methods
      allow_origins = var.cors_allow_origins
      expose_headers = var.cors_expose_headers
      max_age = var.cors_max_age
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-api"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# API Gateway Resource
resource "aws_api_gateway_resource" "resources" {
  for_each = { for idx, path in var.api_paths : path.path_part => path }
  
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = lookup(each.value, "parent_id", aws_api_gateway_rest_api.this.root_resource_id)
  path_part   = each.value.path_part
}

# API Gateway Methods
resource "aws_api_gateway_method" "methods" {
  for_each = { for idx, method in var.api_methods : "${method.resource_path_part}-${method.http_method}" => method }
  
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = lookup(aws_api_gateway_resource.resources, each.value.resource_path_part, aws_api_gateway_rest_api.this.root_resource_id)
  http_method   = each.value.http_method
  authorization = each.value.authorization_type
  authorizer_id = each.value.authorization_type == "CUSTOM" || each.value.authorization_type == "COGNITO_USER_POOLS" ? each.value.authorizer_id : null
  
  # API Key settings
  api_key_required = lookup(each.value, "api_key_required", false)
  
  # Request parameters
  request_parameters = lookup(each.value, "request_parameters", {})
  
  # Request models
  request_models = lookup(each.value, "request_models", {})
}

# Lambda integration
resource "aws_api_gateway_integration" "lambda" {
  for_each = { for idx, method in var.api_methods : "${method.resource_path_part}-${method.http_method}" => method if method.integration_type == "AWS_PROXY" }
  
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = lookup(aws_api_gateway_resource.resources, each.value.resource_path_part, aws_api_gateway_rest_api.this.root_resource_id)
  http_method             = aws_api_gateway_method.methods["${each.value.resource_path_part}-${each.value.http_method}"].http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value.integration_uri
  
  # Credentials for API Gateway to invoke the Lambda
  credentials             = lookup(each.value, "integration_credentials", null)
  
  # Request parameters
  request_parameters       = lookup(each.value, "integration_request_parameters", {})
  
  # Cache settings
  cache_key_parameters     = lookup(each.value, "cache_key_parameters", [])
  cache_namespace          = lookup(each.value, "cache_namespace", each.value.resource_path_part)
}

# HTTP integration
resource "aws_api_gateway_integration" "http" {
  for_each = { for idx, method in var.api_methods : "${method.resource_path_part}-${method.http_method}" => method if method.integration_type == "HTTP" || method.integration_type == "HTTP_PROXY" }
  
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = lookup(aws_api_gateway_resource.resources, each.value.resource_path_part, aws_api_gateway_rest_api.this.root_resource_id)
  http_method             = aws_api_gateway_method.methods["${each.value.resource_path_part}-${each.value.http_method}"].http_method
  
  type                    = each.value.integration_type
  uri                     = each.value.integration_uri
  integration_http_method = lookup(each.value, "integration_http_method", each.value.http_method)
  
  # Request parameters and templates
  request_parameters       = lookup(each.value, "integration_request_parameters", {})
  request_templates        = lookup(each.value, "integration_request_templates", {})
  
  # Cache settings
  cache_key_parameters     = lookup(each.value, "cache_key_parameters", [])
  cache_namespace          = lookup(each.value, "cache_namespace", each.value.resource_path_part)
  
  # If not a proxy integration, set up response mapping
  dynamic "integration_response" {
    for_each = each.value.integration_type == "HTTP" ? [true] : []
    content {
      status_code = "200"
      response_templates = {
        "application/json" = ""
      }
    }
  }
}

# MOCK integration
resource "aws_api_gateway_integration" "mock" {
  for_each = { for idx, method in var.api_methods : "${method.resource_path_part}-${method.http_method}" => method if method.integration_type == "MOCK" }
  
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = lookup(aws_api_gateway_resource.resources, each.value.resource_path_part, aws_api_gateway_rest_api.this.root_resource_id)
  http_method             = aws_api_gateway_method.methods["${each.value.resource_path_part}-${each.value.http_method}"].http_method
  
  type                    = "MOCK"
  request_templates       = lookup(each.value, "integration_request_templates", {
    "application/json" = "{\"statusCode\": 200}"
  })
}

# Method responses
resource "aws_api_gateway_method_response" "responses" {
  for_each = { 
    for resp in flatten([
      for method_key, method in var.api_methods : [
        for status_code in method.response_status_codes : {
          method_key = method_key
          resource_path_part = method.resource_path_part
          http_method = method.http_method
          status_code = status_code
        }
      ]
    ]) : "${resp.method_key}-${resp.status_code}" => resp
  }
  
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = lookup(aws_api_gateway_resource.resources, each.value.resource_path_part, aws_api_gateway_rest_api.this.root_resource_id)
  http_method = aws_api_gateway_method.methods["${each.value.resource_path_part}-${each.value.http_method}"].http_method
  status_code = each.value.status_code
  
  # CORS headers
  response_parameters = var.enable_cors ? {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  } : {}
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.http,
    aws_api_gateway_integration.mock
  ]
  
  rest_api_id = aws_api_gateway_rest_api.this.id
  
  # Force new deployment when configs change
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.body,
      aws_api_gateway_resource.resources,
      aws_api_gateway_method.methods,
      aws_api_gateway_integration.lambda,
      aws_api_gateway_integration.http,
      aws_api_gateway_integration.mock
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
  stage_name    = var.stage_name
  
  # Cache settings
  dynamic "cache_cluster_settings" {
    for_each = var.enable_cache ? [true] : []
    content {
      cache_cluster_enabled = true
      cache_cluster_size    = var.cache_cluster_size
    }
  }
  
  # Logging
  dynamic "access_log_settings" {
    for_each = var.enable_logging ? [true] : []
    content {
      destination_arn = var.log_group_arn
      format          = var.log_format
    }
  }
  
  # X-Ray tracing
  xray_tracing_enabled = var.xray_tracing_enabled
  
  # Stage variables
  variables = var.stage_variables
  
  tags = {
    Name        = "${var.project}-${var.environment}-${var.stage_name}-stage"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Custom Domain Name (if provided)
resource "aws_api_gateway_domain_name" "this" {
  count = var.domain_name != "" ? 1 : 0
  
  domain_name              = var.domain_name
  regional_certificate_arn = var.certificate_arn
  endpoint_configuration {
    types = [var.endpoint_type]
  }
  
  tags = {
    Name        = var.domain_name
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Base Path Mapping
resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.domain_name != "" ? 1 : 0
  
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  base_path   = var.base_path
}

# API Usage Plan
resource "aws_api_gateway_usage_plan" "this" {
  count = var.create_usage_plan ? 1 : 0
  
  name        = "${var.project}-${var.environment}-usage-plan"
  description = "Usage plan for ${var.project}-${var.environment} API"
  
  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }
  
  quota_settings {
    limit  = var.quota_limit
    period = var.quota_period
  }
  
  throttle_settings {
    burst_limit = var.throttle_burst_limit
    rate_limit  = var.throttle_rate_limit
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-usage-plan"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# API Keys (if needed)
resource "aws_api_gateway_api_key" "keys" {
  for_each = toset(var.api_keys)
  
  name = "${var.project}-${var.environment}-${each.value}"
  
  tags = {
    Name        = "${var.project}-${var.environment}-${each.value}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Usage Plan Key Associations
resource "aws_api_gateway_usage_plan_key" "main" {
  for_each = var.create_usage_plan ? toset(var.api_keys) : []
  
  key_id        = aws_api_gateway_api_key.keys[each.value].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this[0].id
}
