output "web_instance_ids" {
  description = "IDs of web server instances"
  value       = aws_instance.web.*.id
}

output "web_private_ips" {
  description = "Private IPs of web server instances"
  value       = aws_instance.web.*.private_ip
}

output "app_instance_ids" {
  description = "IDs of app server instances"
  value       = aws_instance.app.*.id
}

output "app_private_ips" {
  description = "Private IPs of app server instances"
  value       = aws_instance.app.*.private_ip
}

output "bastion_instance_id" {
  description = "ID of bastion host"
  value       = var.enable_bastion ? aws_instance.bastion[0].id : null
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = var.enable_bastion ? aws_instance.bastion[0].public_ip : null
}

output "ec2_iam_role_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_iam_role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}
