output "secret_arns" {
  description = "Map of secret names to ARNs"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => secret.arn
  }
}

output "secret_ids" {
  description = "Map of secret names to IDs"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => secret.id
  }
}

output "secret_versions" {
  description = "Map of secret names to version IDs"
  value = merge(
    {
      for name, version in aws_secretsmanager_secret_version.versions : name => version.version_id
    },
    {
      for name, version in aws_secretsmanager_secret_version.generated_passwords : name => version.version_id
    }
  )
}
