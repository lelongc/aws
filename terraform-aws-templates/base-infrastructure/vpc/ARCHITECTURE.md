# Kiến trúc VPC Module

Tài liệu này mô tả chi tiết kiến trúc của VPC được tạo bởi module này và các best practices được áp dụng.

## Tổng quan kiến trúc

### Cấu trúc VPC

![VPC Architecture](https://d2908q01vomqb2.cloudfront.net/fc074d501302eb2b93e2554793fcaf50b3bf7291/2018/10/19/Fig2.png)

VPC module tạo một kiến trúc multi-tier với:

- **Public Subnets**: Chứa các resource có thể truy cập từ internet (ALB, Bastion hosts)
- **Private Subnets**: Chứa các resource application (EC2, ECS) cần truy cập internet qua NAT Gateway
- **Database Subnets**: Subnet riêng biệt cho databases (RDS, ElastiCache), thường không có route ra internet

### Subnet Distribution

Mỗi subnet được phân bố trên nhiều Availability Zones (AZs) để đảm bảo High Availability:

| Subnet Type | AZ 1          | AZ 2          | AZ 3          |
| ----------- | ------------- | ------------- | ------------- |
| Public      | 10.0.101.0/24 | 10.0.102.0/24 | 10.0.103.0/24 |
| Private     | 10.0.1.0/24   | 10.0.2.0/24   | 10.0.3.0/24   |
| Database    | 10.0.21.0/24  | 10.0.22.0/24  | 10.0.23.0/24  |

### Networking Flow

1. Traffic từ internet đến public subnet thông qua Internet Gateway
2. Applications trong private subnet truy cập internet qua NAT Gateway
3. Database subnets được cô lập hoàn toàn, chỉ cho phép traffic từ private subnets

## Components chi tiết

### Internet Gateway

Internet Gateway được gắn vào VPC để cho phép communication giữa resources trong VPC và internet. Đây là fully managed và highly available AWS service.

### NAT Gateway

NAT Gateway cho phép instances trong private subnet truy cập internet trong khi vẫn duy trì tính private. Module cung cấp hai cấu hình:

1. **Single NAT Gateway**: Một NAT Gateway dùng chung cho tất cả AZs (tiết kiệm chi phí)
2. **Multiple NAT Gateway**: Mỗi AZ có một NAT Gateway riêng (high availability)

### Route Tables

Module tạo các route tables chuyên biệt:

1. **Public Route Table**:

   - Default route (0.0.0.0/0) -> Internet Gateway

2. **Private Route Table(s)**:

   - Default route (0.0.0.0/0) -> NAT Gateway
   - VPC CIDR -> local

3. **Database Route Table**:
   - VPC CIDR -> local
   - Không có route ra internet

### VPC Endpoints

VPC Endpoints cho phép private connection từ VPC đến các AWS services mà không cần internet access:

1. **S3 Endpoint**: Truy cập S3 từ private resources mà không cần NAT Gateway
2. **DynamoDB Endpoint**: Truy cập DynamoDB từ private resources mà không cần NAT Gateway

## Best Practices

### 1. CIDR Block Allocation

- **VPC CIDR**: Sử dụng /16 để có đủ địa chỉ IP cho tương lai (65,536 IPs)
- **Subnet sizing**: Sử dụng /24 cho mỗi subnet (256 IPs)
- **IP Address planning**:
  - Dự trữ không gian IP cho mở rộng
  - Phân bổ nhiều IP hơn cho private subnets

### 2. Security

- **Network segmentation**: Tách biệt các tier bằng subnets riêng
- **Least privilege**: Database không có direct internet access
- **Security groups và NACLs**: Áp dụng theo nguyên tắc least privilege

### 3. High Availability

- **Multi-AZ**: Deploy trên ít nhất 2 AZs, tối ưu là 3 AZs
- **NAT Gateway**: Cân nhắc multiple NAT Gateway cho workloads quan trọng
- **Route Tables**: Route tables riêng cho mỗi loại subnet

### 4. Cost Optimization

- **NAT Gateway**: Sử dụng single NAT Gateway cho non-production environments
- **VPC Endpoints**: Xem xét chi phí của VPC Endpoints so với NAT Gateway

## Design Considerations

### 1. Subnet Sizing

| Environment | VPC CIDR  | Subnet CIDR |
| ----------- | --------- | ----------- |
| Development | /20 - /18 | /24 - /22   |
| Production  | /18 - /16 | /24 - /23   |

### 2. NAT Gateway vs NAT Instance

| Feature      | NAT Gateway                   | NAT Instance            |
| ------------ | ----------------------------- | ----------------------- |
| Availability | Managed by AWS                | Self-managed            |
| Bandwidth    | Up to 45 Gbps                 | Instance type dependent |
| Cost         | Hourly rate + data processing | EC2 instance cost       |
| Maintenance  | None                          | OS patching required    |

### 3. VPC Peering vs Transit Gateway

Cho multiple VPC connectivity:

| Feature                | VPC Peering                   | Transit Gateway       |
| ---------------------- | ----------------------------- | --------------------- |
| Max connections        | 125 per VPC                   | Thousands of VPCs     |
| Transitive Routing     | No                            | Yes                   |
| Route Table Management | Each peering connection       | Centralized           |
| Cost                   | Free connection, data charges | Hourly + data charges |

## Kịch bản triển khai

### 1. Multi-Environment Deployment

```hcl
# Development Environment
module "vpc_dev" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  name        = "app"
  environment = "dev"

  vpc_cidr        = "10.0.0.0/18"
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.32.0/24", "10.0.33.0/24"]
  database_subnets = ["10.0.48.0/24", "10.0.49.0/24"]

  single_nat_gateway = true
}

# Production Environment
module "vpc_prod" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  name        = "app"
  environment = "prod"

  vpc_cidr        = "10.1.0.0/16"
  private_subnets = ["10.1.0.0/23", "10.1.2.0/23", "10.1.4.0/23"]
  public_subnets  = ["10.1.100.0/24", "10.1.101.0/24", "10.1.102.0/24"]
  database_subnets = ["10.1.200.0/24", "10.1.201.0/24", "10.1.202.0/24"]

  single_nat_gateway = false
  enable_s3_endpoint = true
  enable_dynamodb_endpoint = true
}
```

### 2. Multi-Region Deployment

```hcl
module "vpc_us_east" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  providers = {
    aws = aws.us_east_1
  }

  # ...VPC variables...
}

module "vpc_eu_west" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  providers = {
    aws = aws.eu_west_1
  }

  # ...VPC variables...
}
```
