output "key_ids" {
  description = "Map of key names to KMS key IDs"
  value = {
    for name, key in aws_kms_key.keys : name => key.key_id
  }
}

output "key_arns" {
  description = "Map of key names to KMS key ARNs"
  value = {
    for name, key in aws_kms_key.keys : name => key.arn
  }
}

output "aliases" {
  description = "Map of key names to KMS key aliases"
  value = {
    for name, alias in aws_kms_alias.aliases : name => alias.name
  }
}
