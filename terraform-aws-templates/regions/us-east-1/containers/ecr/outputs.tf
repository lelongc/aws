output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}

output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.arn }
}

output "repository_ids" {
  description = "IDs of the ECR repositories"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.registry_id }
}

output "public_repository_urls" {
  description = "URLs of the public ECR repositories"
  value       = { for name, repo in aws_ecrpublic_repository.public : name => repo.repository_uri }
}

output "public_repository_arns" {
  description = "ARNs of the public ECR repositories"
  value       = { for name, repo in aws_ecrpublic_repository.public : name => repo.arn }
}
