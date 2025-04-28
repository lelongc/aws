provider "aws" {
  region = var.region
}

# Elastic IPs for NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0
  
  domain = "vpc"
  
  tags = {
    Name        = "${var.project}-${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(var.public_subnet_ids, count.index)
  
  tags = {
    Name        = "${var.project}-${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
  
  depends_on = [var.internet_gateway_id]
}

# Private route table for NAT Gateway
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0
  
  vpc_id = var.vpc_id
  
  tags = {
    Name        = "${var.project}-${var.environment}-private-route-table-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Route for internet access via NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
  
  timeouts {
    create = "5m"
  }
}
