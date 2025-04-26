# AWS VPC Terraform Module

Module này tạo ra một VPC hoàn chỉnh trên AWS với các subnet public, private và database, cùng với các thành phần như Internet Gateway, NAT Gateway và VPC Endpoints.

## Tính năng

- VPC với DNS hostnames và DNS support
- Subnet public, private và database trên nhiều Availability Zone
- Internet Gateway cho subnet public
- NAT Gateway cho subnet private (với tùy chọn single NAT hoặc multiple NAT)
- Route tables cho mỗi loại subnet
- Database subnet group cho RDS
- VPC Endpoints cho S3 và DynamoDB (tùy chọn)
- IPv6 support (tùy chọn)
- Tùy chọn tagging linh hoạt

## Sử dụng cơ bản

```hcl
module "vpc" {
  source = "./path/to/terraform-aws-templates/base-infrastructure/vpc"

  name        = "my-project"
  environment = "dev"

  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
```

## Biến đầu vào

| Tên                      | Mô tả                                           |     Loại     |                       Default                       |
| ------------------------ | ----------------------------------------------- | :----------: | :-------------------------------------------------: |
| region                   | AWS Region                                      |    string    |                     "us-east-1"                     |
| name                     | Prefix cho tên resource                         |    string    |                       "main"                        |
| environment              | Môi trường (dev, test, prod, etc)               |    string    |                        "dev"                        |
| vpc_cidr                 | CIDR block cho VPC                              |    string    |                    "10.0.0.0/16"                    |
| azs                      | List các AZ được sử dụng                        | list(string) |     ["us-east-1a", "us-east-1b", "us-east-1c"]      |
| private_subnets          | CIDR cho private subnets                        | list(string) |    ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]    |
| public_subnets           | CIDR cho public subnets                         | list(string) | ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] |
| database_subnets         | CIDR cho database subnets                       | list(string) |  ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]   |
| enable_nat_gateway       | Bật NAT Gateway                                 |     bool     |                        true                         |
| single_nat_gateway       | Dùng một NAT Gateway cho tất cả private subnets |     bool     |                        true                         |
| enable_s3_endpoint       | Tạo VPC endpoint cho S3                         |     bool     |                        false                        |
| enable_dynamodb_endpoint | Tạo VPC endpoint cho DynamoDB                   |     bool     |                        false                        |

Xem thêm biến đầu vào trong file [variables.tf](./variables.tf).

## Đầu ra

| Tên                   | Mô tả                        |
| --------------------- | ---------------------------- |
| vpc_id                | ID của VPC                   |
| vpc_arn               | ARN của VPC                  |
| private_subnets       | List ID các private subnet   |
| public_subnets        | List ID các public subnet    |
| database_subnets      | List ID các database subnet  |
| database_subnet_group | ID của database subnet group |
| nat_public_ips        | List IPs cho NAT Gateways    |
| igw_id                | ID của Internet Gateway      |

Xem thêm đầu ra trong file [outputs.tf](./outputs.tf).

## Kiến trúc VPC

VPC được tạo ra có kiến trúc như sau:

```
VPC (10.0.0.0/16)
│
├── Public Subnets (10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24)
│   ├── Internet Gateway
│   └── Route table
│
├── Private Subnets (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24)
│   ├── NAT Gateway(s)
│   └── Route table(s)
│
└── Database Subnets (10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24)
    └── Database subnet group
```

## Single vs Multiple NAT Gateway

Có hai tùy chọn cho NAT Gateway:

1. **Single NAT Gateway (mặc định)**: Tiết kiệm chi phí nhưng giảm tính sẵn sàng. Tất cả private subnets sử dụng cùng một NAT Gateway.

2. **Multiple NAT Gateway**: Tăng tính sẵn sàng nhưng tăng chi phí. Mỗi AZ có một NAT Gateway riêng.

Để sử dụng multiple NAT Gateway:

```hcl
enable_nat_gateway = true
single_nat_gateway = false
```

## VPC Endpoints

Module hỗ trợ Gateway VPC Endpoints cho:

- Amazon S3
- DynamoDB

Để bật các endpoints này:

```hcl
enable_s3_endpoint = true
enable_dynamodb_endpoint = true
```

## Best Practices

1. **Tagging**: Sử dụng tagging nhất quán qua biến `additional_tags`:

   ```hcl
   additional_tags = {
     CostCenter   = "IT-123456"
     BusinessUnit = "Marketing"
   }
   ```

2. **CIDR blocks**: Dùng kích thước subnet phù hợp với nhu cầu. Private subnets thường cần nhiều địa chỉ IP hơn public subnets.

3. **NAT Gateway**: Với môi trường non-production, dùng `single_nat_gateway = true` để tiết kiệm chi phí.
