provider "aws" {
  region = var.region
}

# Secrets Manager Secrets
resource "aws_secretsmanager_secret" "secrets" {
  for_each = { for secret in var.secrets : secret.name => secret }
  
  name        = "${var.project}/${var.environment}/${each.value.name}"
  description = lookup(each.value, "description", "Secret for ${each.value.name}")
  kms_key_id  = lookup(each.value, "kms_key_id", null)
  
  recovery_window_in_days = lookup(each.value, "recovery_window_in_days", 30)
  
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

# Secret Values
resource "aws_secretsmanager_secret_version" "versions" {
  for_each = { 
    for secret in var.secrets : 
    secret.name => secret 
    if lookup(secret, "value", null) != null || lookup(secret, "value_map", null) != null
  }
  
  secret_id = aws_secretsmanager_secret.secrets[each.key].id
  
  secret_string = lookup(each.value, "value_map", null) != null ? jsonencode(each.value.value_map) : each.value.value
}

# Secret Policy
resource "aws_secretsmanager_secret_policy" "policies" {
  for_each = { 
    for secret in var.secrets : 
    secret.name => secret 
    if lookup(secret, "policy", null) != null
  }
  
  secret_arn = aws_secretsmanager_secret.secrets[each.key].arn
  policy     = each.value.policy
}

# Resource policy for all secrets if provided
resource "aws_secretsmanager_secret_policy" "global_policy" {
  count = var.global_secret_policy != null ? 1 : 0
  
  secret_arn = aws_secretsmanager_secret.secrets[keys(aws_secretsmanager_secret.secrets)[0]].arn
  policy     = var.global_secret_policy
}

# Random password generator for secrets that need it
resource "random_password" "passwords" {
  for_each = { 
    for secret in var.secrets : 
    secret.name => secret 
    if lookup(secret, "generate_random_password", false)
  }
  
  length           = lookup(each.value, "password_length", 16)
  special          = lookup(each.value, "include_special_chars", true)
  override_special = lookup(each.value, "special_chars", "!@#$%^&*()-_=+[]{}<>:?")
}

# Store generated passwords in Secrets Manager
resource "aws_secretsmanager_secret_version" "generated_passwords" {
  for_each = random_password.passwords
  
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.result
}
