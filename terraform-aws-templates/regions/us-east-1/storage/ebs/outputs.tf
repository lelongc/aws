output "volume_ids" {
  description = "Map of volume names to volume IDs"
  value       = { for name, volume in aws_ebs_volume.this : name => volume.id }
}

output "volume_arns" {
  description = "Map of volume names to volume ARNs"
  value       = { for name, volume in aws_ebs_volume.this : name => volume.arn }
}

output "volume_attachment_ids" {
  description = "Map of volume names to volume attachment IDs"
  value = {
    for name, attachment in aws_volume_attachment.this :
    name => attachment.id
  }
}

output "kms_key_id" {
  description = "ID of the KMS key used for EBS encryption"
  value       = var.create_kms_key ? aws_kms_key.ebs[0].key_id : null
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for EBS encryption"
  value       = var.create_kms_key ? aws_kms_key.ebs[0].arn : null
}

output "dlm_policy_id" {
  description = "ID of the DLM lifecycle policy for EBS snapshots"
  value       = var.enable_snapshot_lifecycle ? aws_dlm_lifecycle_policy.ebs_snapshot_policy[0].id : null
}

output "dlm_policy_arn" {
  description = "ARN of the DLM lifecycle policy for EBS snapshots"
  value       = var.enable_snapshot_lifecycle ? aws_dlm_lifecycle_policy.ebs_snapshot_policy[0].arn : null
}
