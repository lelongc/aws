provider "aws" {
  region = var.region
}

# Get current account ID
data "aws_caller_identity" "current" {}

# Create KMS keys
resource "aws_kms_key" "keys" {
  for_each = { for key in var.kms_keys : key.name => key }
  
  description             = lookup(each.value, "description", "KMS key for ${each.value.name}")
  deletion_window_in_days = lookup(each.value, "deletion_window_in_days", 30)
  key_usage               = lookup(each.value, "key_usage", "ENCRYPT_DECRYPT")
  customer_master_key_spec = lookup(each.value, "customer_master_key_spec", "SYMMETRIC_DEFAULT")
  is_enabled             = lookup(each.value, "is_enabled", true)
  enable_key_rotation    = lookup(each.value, "enable_key_rotation", true)
  
  policy = lookup(each.value, "policy", null) != null ? each.value.policy : jsonencode({
    Version = "2012-10-17"
    Id      = "${each.value.name}-key-policy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = lookup(each.value, "key_users", [])
        }
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
      }
    ]
  })
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}-key"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    lookup(each.value, "tags", {})
  )
}

# Create aliases for KMS keys
resource "aws_kms_alias" "aliases" {
  for_each = { for key in var.kms_keys : key.name => key }
  
  name          = "alias/${var.project}-${var.environment}-${each.value.name}"
  target_key_id = aws_kms_key.keys[each.key].key_id
}

# Grant permissions to use the keys
resource "aws_kms_grant" "grants" {
  for_each = { 
    for grant in flatten([
      for key_name, key in var.kms_keys : [
        for grant in lookup(key, "grants", []) : {
          key_name    = key_name
          name        = grant.name
          grantee_principal = grant.grantee_principal
          operations  = grant.operations
        }
      ]
    ]) : "${grant.key_name}-${grant.name}" => grant
  }
  
  name              = each.value.name
  key_id            = aws_kms_key.keys[each.value.key_name].key_id
  grantee_principal = each.value.grantee_principal
  operations        = each.value.operations
}
