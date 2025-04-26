provider "aws" {
  region = var.region
}

locals {
  name        = var.name
  environment = var.environment
  vpc_name    = "${local.name}-vpc-${local.environment}"
  
  tags = {
    Name        = local.vpc_name
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  
  tags = merge(
    local.tags,
    var.additional_tags,
    {
      "Name" = local.vpc_name
    },
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-igw"
    },
  )
}

################################################################################
# Public Subnets
################################################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.public_subnets[count.index]
  availability_zone               = length(var.azs) > 0 ? var.azs[count.index % length(var.azs)] : null
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  
  tags = merge(
    local.tags,
    {
      "Name" = format(
        "${local.vpc_name}-public-%s",
        element(var.azs, count.index % length(var.azs)),
      )
    },
    var.public_subnet_tags,
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-public-rt"
    },
    var.public_route_table_tags,
  )
}

# Public Routes
resource "aws_route" "public_internet_gateway" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.private_subnets[count.index]
  availability_zone               = length(var.azs) > 0 ? var.azs[count.index % length(var.azs)] : null

  tags = merge(
    local.tags,
    {
      "Name" = format(
        "${local.vpc_name}-private-%s",
        element(var.azs, count.index % length(var.azs)),
      )
    },
    var.private_subnet_tags,
  )
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && !var.reuse_nat_ips ? var.single_nat_gateway ? 1 : length(var.public_subnets) : 0

  domain = "vpc"

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-nat-eip-${count.index + 1}"
    },
    var.nat_eip_tags,
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? var.single_nat_gateway ? 1 : length(var.public_subnets) : 0

  allocation_id = var.reuse_nat_ips ? var.external_nat_ip_ids[count.index] : aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-natgw-${count.index + 1}"
    },
    var.nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.this]
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? var.single_nat_gateway ? 1 : length(var.private_subnets) : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      "Name" = var.single_nat_gateway ? "${local.vpc_name}-private-rt" : "${local.vpc_name}-private-rt-${count.index + 1}"
    },
    var.private_route_table_tags,
  )
}

# Private Routes
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? var.single_nat_gateway ? 1 : length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, var.single_nat_gateway ? 0 : count.index)

  timeouts {
    create = "5m"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

################################################################################
# Database Subnets
################################################################################

resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.database_subnets[count.index]
  availability_zone               = length(var.azs) > 0 ? var.azs[count.index % length(var.azs)] : null

  tags = merge(
    local.tags,
    {
      "Name" = format(
        "${local.vpc_name}-db-%s",
        element(var.azs, count.index % length(var.azs)),
      )
    },
    var.database_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0

  name        = lower(var.database_subnet_group_name != "" ? var.database_subnet_group_name : "${local.vpc_name}-db-subnet-group")
  description = "Database subnet group for ${local.vpc_name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    local.tags,
    {
      "Name" = lower(var.database_subnet_group_name != "" ? var.database_subnet_group_name : "${local.vpc_name}-db-subnet-group")
    },
    var.database_subnet_group_tags,
  )
}

################################################################################
# VPC Endpoints
################################################################################

# Gateway Endpoints (S3 & DynamoDB)
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = flatten([
    aws_route_table.public[*].id,
    aws_route_table.private[*].id,
  ])

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-s3-endpoint"
    },
    var.vpc_endpoint_tags,
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = flatten([
    aws_route_table.public[*].id,
    aws_route_table.private[*].id,
  ])

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc_name}-dynamodb-endpoint"
    },
    var.vpc_endpoint_tags,
  )
}
