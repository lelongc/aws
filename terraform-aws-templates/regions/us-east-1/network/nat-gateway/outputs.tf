output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this.*.id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private.*.id
}

output "nat_gateway_allocation_ids" {
  description = "List of allocation IDs of the NAT EIPs"
  value       = aws_eip.nat.*.allocation_id
}

output "nat_gateway_count" {
  description = "Number of NAT Gateways created"
  value       = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0
}
