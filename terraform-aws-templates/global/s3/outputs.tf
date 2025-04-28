output "terraform_state_bucket_name" {
  description = "The name of the terraform state bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "The ARN of the terraform state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "logging_bucket_name" {
  description = "The name of the logging bucket"
  value       = aws_s3_bucket.logging.bucket
}

output "logging_bucket_arn" {
  description = "The ARN of the logging bucket"
  value       = aws_s3_bucket.logging.arn
}

output "artifacts_bucket_name" {
  description = "The name of the artifacts bucket"
  value       = aws_s3_bucket.artifacts.bucket
}

output "artifacts_bucket_arn" {
  description = "The ARN of the artifacts bucket"
  value       = aws_s3_bucket.artifacts.arn
}
