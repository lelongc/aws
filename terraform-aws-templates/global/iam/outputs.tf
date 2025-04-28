output "admin_role_arn" {
  description = "ARN of the admin IAM role"
  value       = aws_iam_role.admin_role.arn
}

output "developer_role_arn" {
  description = "ARN of the developer IAM role"
  value       = aws_iam_role.developer_role.arn
}

output "admin_users" {
  description = "List of admin users created"
  value       = [for user in aws_iam_user.admin_users : user.name]
}

output "developer_users" {
  description = "List of developer users created"
  value       = [for user in aws_iam_user.developer_users : user.name]
}
