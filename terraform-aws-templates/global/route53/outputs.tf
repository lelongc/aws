output "root_zone_id" {
  description = "ID of the root hosted zone"
  value       = var.create_root_zone ? aws_route53_zone.main[0].zone_id : null
}

output "root_zone_name_servers" {
  description = "Name servers of the root hosted zone"
  value       = var.create_root_zone ? aws_route53_zone.main[0].name_servers : null
}

output "environment_zone_id" {
  description = "ID of the environment hosted zone"
  value       = var.create_env_zone ? aws_route53_zone.environment[0].zone_id : null
}

output "environment_zone_name_servers" {
  description = "Name servers of the environment hosted zone"
  value       = var.create_env_zone ? aws_route53_zone.environment[0].name_servers : null
}

output "www_record_fqdn" {
  description = "FQDN of the www record"
  value       = var.create_env_zone ? aws_route53_record.www[0].fqdn : null
}

output "api_record_fqdn" {
  description = "FQDN of the API record"
  value       = var.create_env_zone && var.create_api_record ? aws_route53_record.api[0].fqdn : null
}
