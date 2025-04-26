# Hướng dẫn sử dụng VPC Terraform Module

Tài liệu này cung cấp hướng dẫn chi tiết về cách sử dụng module VPC, với các ví dụ và tình huống phổ biến.

## Các tình huống sử dụng

### 1. VPC cơ bản với subnet public và private

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  name        = "app"
  environment = "dev"

  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
```

### 2. VPC cho môi trường Production với High Availability

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  name        = "app"
  environment = "prod"

  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  # High Availability: Mỗi AZ có một NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = false

  # Gateway VPC Endpoints
  enable_s3_endpoint = true
  enable_dynamodb_endpoint = true
}
```

### 3. VPC cho môi trường Development (tiết kiệm chi phí)

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  name        = "app"
  environment = "dev"

  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  # Tiết kiệm chi phí với single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
}
```

## Tích hợp với các module khác

### Sử dụng với EC2

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"
  # ... các biến VPC
}

module "ec2" {
  source = "./terraform-aws-templates/compute/ec2"

  # Sử dụng output từ module VPC
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.private_subnets[0]
}
```

### Sử dụng với RDS

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"
  # ... các biến VPC với database_subnets
}

module "rds" {
  source = "./terraform-aws-templates/storage/rds"

  # Sử dụng database subnet group từ module VPC
  db_subnet_group_name = module.vpc.database_subnet_group
}
```

## Mẹo và thủ thuật

### 1. Tùy chỉnh route tables

Mặc định, module tạo route tables riêng cho mỗi loại subnet. Nếu bạn cần thêm routes tùy chỉnh, bạn có thể sử dụng resource `aws_route` bổ sung:

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"
  # ... các biến VPC
}

resource "aws_route" "additional_route" {
  route_table_id         = module.vpc.private_route_tables[0]
  destination_cidr_block = "172.16.0.0/12"
  transit_gateway_id     = aws_ec2_transit_gateway.example.id
}
```

### 2. Sử dụng tags hiệu quả

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  # ... các biến cơ bản

  # Tags chung
  additional_tags = {
    Project     = "ProjectX"
    CostCenter  = "12345"
    Owner       = "Team-DevOps"
  }

  # Tags riêng cho từng thành phần
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    Tier = "Public"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    Tier = "Private"
  }

  database_subnet_tags = {
    Tier = "Database"
  }
}
```

### 3. Sử dụng conditional expressions

Bạn có thể sử dụng biểu thức điều kiện để tùy chỉnh module:

```hcl
locals {
  is_production = var.environment == "prod"
}

module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  # ... các biến cơ bản

  # NAT Gateway tùy theo môi trường
  enable_nat_gateway = true
  single_nat_gateway = local.is_production ? false : true

  # Endpoints tùy theo môi trường
  enable_s3_endpoint = local.is_production
  enable_dynamodb_endpoint = local.is_production
}
```

## Khắc phục sự cố

### Lỗi khi xóa resource

Nếu bạn gặp lỗi khi xóa resource, đảm bảo rằng bạn đã xóa tất cả các resource phụ thuộc trước:

1. Xóa EC2 instances, RDS, ELB trước khi xóa Security Groups và Subnets
2. Xóa NAT Gateway trước khi xóa Elastic IPs và Internet Gateway

### Xem logs chi tiết

```shell
export TF_LOG=DEBUG
terraform apply
```

## Các tham số nâng cao

### 1. CIDR Blocks

Đây là một số đề xuất cho CIDR blocks:

- **VPC**: /16 (65,536 địa chỉ) hoặc /18 (16,384 địa chỉ)
- **Subnets**: /24 (256 địa chỉ) cho hầu hết các mục đích
- **Phân bổ**: Dành 50-60% địa chỉ cho private subnets

### 2. NAT Gateway Scaling

- **Single NAT**: Tiết kiệm chi phí, phù hợp cho dev/test
- **Multi NAT**: High availability, phù hợp cho production
