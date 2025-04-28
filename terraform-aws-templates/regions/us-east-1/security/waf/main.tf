provider "aws" {
  region = var.region
}

# AWS WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name        = "${var.project}-${var.environment}-waf"
  description = "WAF Web ACL for ${var.project}-${var.environment}"
  scope       = var.waf_scope

  default_action {
    allow {}
  }

  # AWS Managed Rules
  dynamic "rule" {
    for_each = var.enable_aws_managed_rules ? [1] : []
    content {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 10
      
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
        metric_name                = "AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # SQL Injection Rule
  dynamic "rule" {
    for_each = var.enable_sql_injection_protection ? [1] : []
    content {
      name     = "SQLInjectionRule"
      priority = 20
      
      override_action {
        none {}
      }
      
      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesSQLiRuleSet"
          vendor_name = "AWS"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "SQLInjectionRule"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Bot Control Rule
  dynamic "rule" {
    for_each = var.enable_bot_control ? [1] : []
    content {
      name     = "BotControlRule"
      priority = 30
      
      override_action {
        none {}
      }
      
      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "BotControlRule"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Rate Limit Rule
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      name     = "RateLimitRule"
      priority = 40
      
      action {
        block {}
      }
      
      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimitRule"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # IP Block Rule
  dynamic "rule" {
    for_each = length(var.blocked_ip_addresses) > 0 ? [1] : []
    content {
      name     = "IPBlockRule"
      priority = 50
      
      action {
        block {}
      }
      
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blocked_ips[0].arn
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPBlockRule"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Country Block Rule
  dynamic "rule" {
    for_each = length(var.blocked_countries) > 0 ? [1] : []
    content {
      name     = "CountryBlockRule"
      priority = 60
      
      action {
        block {}
      }
      
      statement {
        geo_match_statement {
          country_codes = var.blocked_countries
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "CountryBlockRule"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Custom Rules
  dynamic "rule" {
    for_each = var.custom_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      
      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }
      
      statement {
        dynamic "byte_match_statement" {
          for_each = rule.value.statement_type == "byte_match" ? [rule.value.statement] : []
          content {
            positional_constraint = byte_match_statement.value.positional_constraint
            search_string         = byte_match_statement.value.search_string
            
            field_to_match {
              dynamic "uri_path" {
                for_each = byte_match_statement.value.field_to_match == "uri_path" ? [1] : []
                content {}
              }
              dynamic "query_string" {
                for_each = byte_match_statement.value.field_to_match == "query_string" ? [1] : []
                content {}
              }
              dynamic "header" {
                for_each = byte_match_statement.value.field_to_match == "header" ? [1] : []
                content {
                  name = byte_match_statement.value.header_name
                }
              }
            }
            
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Visibility Config for Web ACL
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-${var.environment}-waf"
    sampled_requests_enabled   = true
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-waf"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# IP Set for Blocked IPs
resource "aws_wafv2_ip_set" "blocked_ips" {
  count = length(var.blocked_ip_addresses) > 0 ? 1 : 0
  
  name               = "${var.project}-${var.environment}-blocked-ips"
  description        = "Blocked IP addresses"
  scope              = var.waf_scope
  ip_address_version = "IPV4"
  addresses          = var.blocked_ip_addresses
  
  tags = {
    Name        = "${var.project}-${var.environment}-blocked-ips"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Web ACL Association with ALB
resource "aws_wafv2_web_acl_association" "alb" {
  count = var.alb_arn != null ? 1 : 0
  
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# Web ACL Association with CloudFront
resource "aws_wafv2_web_acl_association" "cloudfront" {
  count = var.cloudfront_id != null ? 1 : 0
  
  resource_arn = var.cloudfront_id
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = var.enable_logging ? 1 : 0
  
  log_destination_configs = [var.log_destination_arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
  
  dynamic "redacted_fields" {
    for_each = var.redacted_fields
    content {
      dynamic "single_header" {
        for_each = redacted_fields.value.type == "single_header" ? [redacted_fields.value] : []
        content {
          name = single_header.value.name
        }
      }
    }
  }
}
