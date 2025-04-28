provider "aws" {
  region = var.region
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description                     = "Transit Gateway for ${var.project}-${var.environment}"
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  
  tags = {
    Name        = "${var.project}-${var.environment}-tgw"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  
  tags = {
    Name        = "${var.project}-${var.environment}-tgw-rt"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# VPC attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = length(var.vpc_attachments)
  
  subnet_ids         = var.vpc_attachments[count.index].subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_attachments[count.index].vpc_id
  
  dns_support                                     = try(var.vpc_attachments[count.index].dns_support, "enable")
  ipv6_support                                    = try(var.vpc_attachments[count.index].ipv6_support, "disable")
  appliance_mode_support                          = try(var.vpc_attachments[count.index].appliance_mode_support, "disable")
  transit_gateway_default_route_table_association = try(var.vpc_attachments[count.index].transit_gateway_default_route_table_association, true)
  transit_gateway_default_route_table_propagation = try(var.vpc_attachments[count.index].transit_gateway_default_route_table_propagation, true)
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-tgw-attachment-${var.vpc_attachments[count.index].name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    try(var.vpc_attachments[count.index].tags, {})
  )
}

# Routes (destination CIDR blocks to other VPCs)
resource "aws_ec2_transit_gateway_route" "this" {
  count = length(var.tgw_routes)
  
  destination_cidr_block         = var.tgw_routes[count.index].destination_cidr_block
  transit_gateway_attachment_id  = var.tgw_routes[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}
