output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway route table"
  value       = aws_ec2_transit_gateway_route_table.this.id
}

output "transit_gateway_vpc_attachment_ids" {
  description = "List of Transit Gateway VPC attachment IDs"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.*.id
}

output "transit_gateway_owner_id" {
  description = "ID of the AWS account that owns the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.owner_id
}

output "transit_gateway_association_default_route_table_id" {
  description = "ID of the default association route table"
  value       = aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "ID of the default propagation route table"
  value       = aws_ec2_transit_gateway.this.propagation_default_route_table_id
}
