output "file_system_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  description = "ARN of the EFS file system"
  value       = aws_efs_file_system.this.arn
}

output "file_system_dns_name" {
  description = "DNS name of the EFS file system"
  value       = "${aws_efs_file_system.this.id}.efs.${var.region}.amazonaws.com"
}

output "mount_target_ids" {
  description = "IDs of the EFS mount targets"
  value       = aws_efs_mount_target.this.*.id
}

output "mount_target_dns_names" {
  description = "DNS names of the EFS mount targets"
  value = [
    for i in range(length(var.subnet_ids)) :
    "${aws_efs_file_system.this.id}.efs.${var.region}.amazonaws.com"
  ]
}

output "security_group_id" {
  description = "ID of the security group created for EFS"
  value       = var.create_security_group ? aws_security_group.efs[0].id : null
}

output "access_point_ids" {
  description = "IDs of the EFS access points"
  value       = { for name, ap in aws_efs_access_point.this : name => ap.id }
}

output "access_point_arns" {
  description = "ARNs of the EFS access points"
  value       = { for name, ap in aws_efs_access_point.this : name => ap.arn }
}

output "kms_key_id" {
  description = "ID of the KMS key used for EFS encryption"
  value       = var.create_kms_key ? aws_kms_key.efs[0].key_id : var.kms_key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for EFS encryption"
  value       = var.create_kms_key ? aws_kms_key.efs[0].arn : null
}
