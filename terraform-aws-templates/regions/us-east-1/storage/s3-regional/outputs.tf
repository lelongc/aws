output "bucket_ids" {
  description = "Map of bucket names to bucket IDs"
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.id }
}

output "bucket_arns" {
  description = "Map of bucket names to bucket ARNs"
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.arn }
}

output "bucket_domain_names" {
  description = "Map of bucket names to bucket domain names"
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.bucket_domain_name }
}

output "bucket_regional_domain_names" {
  description = "Map of bucket names to bucket regional domain names"
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.bucket_regional_domain_name }
}
