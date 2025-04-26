output "web_security_group_id" {
  description = "ID of web tier security group"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "ID of app tier security group"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "ID of database tier security group"
  value       = aws_security_group.db.id
}

output "bastion_security_group_id" {
  description = "ID of bastion host security group"
  value       = aws_security_group.bastion.id
}

output "alb_security_group_id" {
  description = "ID of application load balancer security group"
  value       = aws_security_group.alb.id
}
