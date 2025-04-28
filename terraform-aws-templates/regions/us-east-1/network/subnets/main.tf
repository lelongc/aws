provider "aws" {
  region = var.region
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Type        = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Type        = "Private"
  }
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.database_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-database-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Type        = "Database"
  }
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = var.public_route_table_id
}

# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = element(var.private_route_table_ids, count.index)
}

# Route Table Associations for Database Subnets
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = element(var.private_route_table_ids, count.index)
}

# DB Subnet Group
resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnet_cidrs) > 0 ? 1 : 0
  
  name        = "${var.project}-${var.environment}-db-subnet-group"
  description = "Database subnet group for ${var.project}-${var.environment}"
  subnet_ids  = aws_subnet.database.*.id

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-group"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "elasticache" {
  count = var.create_elasticache_subnet_group && length(var.private_subnet_cidrs) > 0 ? 1 : 0
  
  name        = "${var.project}-${var.environment}-elasticache-subnet-group"
  description = "Elasticache subnet group for ${var.project}-${var.environment}"
  subnet_ids  = aws_subnet.private.*.id

  tags = {
    Name        = "${var.project}-${var.environment}-elasticache-subnet-group"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
