output "id" {
  description = "List of IDs of instances"
  value       = aws_instance.this.*.id
}

output "arn" {
  description = "List of ARNs of instances"
  value       = aws_instance.this.*.arn
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of instances"
  value       = aws_instance.this.*.capacity_reservation_specification
}

output "instance_state" {
  description = "List of instance states"
  value       = aws_instance.this.*.instance_state
}

output "primary_network_interface_id" {
  description = "List of IDs of the primary network interface"
  value       = aws_instance.this.*.primary_network_interface_id
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances"
  value       = aws_instance.this.*.private_dns
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = aws_instance.this.*.public_dns
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.this.*.public_ip
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.this.*.private_ip
}

output "tags_all" {
  description = "A map of tags assigned to the resources"
  value       = aws_instance.this.*.tags_all
}
