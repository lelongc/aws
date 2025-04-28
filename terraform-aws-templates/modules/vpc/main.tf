resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0
  
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    {
      Name = "${var.name}-igw"
    },
    var.tags
  )
}

# Public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  
  tags = merge(
    {
      Name = "${var.name}-public-${element(var.availability_zones, count.index)}"
      Type = "Public"
    },
    var.tags
  )
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  
  tags = merge(
    {
      Name = "${var.name}-private-${element(var.availability_zones, count.index)}"
      Type = "Private"
    },
    var.tags
  )
}

# Public route table
resource "aws_route_table" "public" {
  count = var.create_internet_gateway ? 1 : 0
  
  vpc_id = aws_vpc.this.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  
  tags = merge(
    {
      Name = "${var.name}-public-rt"
    },
    var.tags
  )
}

# Private route tables
resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    {
      Name = "${var.name}-private-rt-${element(var.availability_zones, count.index)}"
    },
    var.tags
  )
}

# Public route table associations
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Private route table associations
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# NAT Gateway (optional)
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0
  
  domain = "vpc"
  
  tags = merge(
    {
      Name = "${var.name}-nat-eip-${count.index + 1}"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(
    {
      Name = "${var.name}-nat-gw-${count.index + 1}"
    },
    var.tags
  )
  
  depends_on = [aws_internet_gateway.this]
}

# NAT routes for private subnets
resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? length(var.private_subnets) : 0
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}
