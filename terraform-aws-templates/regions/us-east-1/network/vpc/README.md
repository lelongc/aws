# VPC Module

Module này tạo VPC với đầy đủ các thành phần cần thiết:

- VPC với CIDR block tùy chỉnh
- Internet Gateway
- Route Tables
- NAT Gateway (tùy chọn)

## Cách sử dụng

```hcl
module "vpc" {
  source = "../../../../regions/us-east-1/network/vpc"

  environment     = "dev"
  project         = "my-project"
  vpc_cidr_block  = "10.0.0.0/16"
  enable_nat_gateway = true
}
```

## Inputs

| Tên | Mô tả | Loại | Default | Required |
|-----|--------|------|---------|:--------:|
| environment | Môi trường (dev/staging/prod) | string | - | yes |
| project | Tên project | string | - | yes |
| vpc_cidr_block | CIDR block cho VPC | string | "10.0.0.0/16" | no |
| enable_nat_gateway | Bật NAT Gateway | bool | false | no |
