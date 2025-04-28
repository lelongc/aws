# IAM Module

Module này quản lý tất cả các tài nguyên Identity and Access Management (IAM) cho AWS.

## Tài nguyên được tạo

- IAM Roles
- IAM Users
- IAM Groups
- IAM Policies

## Cách sử dụng

```hcl
module "iam" {
  source = "../../global/iam"

  environment = "dev"
  
  # Xem thêm các biến trong variables.tf
}
```

## Inputs

| Tên | Mô tả | Loại | Default | Required |
|-----|--------|------|---------|:--------:|
| environment | Môi trường (dev/staging/prod) | string | - | yes |
| admin_users | Danh sách IAM users với quyền admin | list(string) | [] | no |
| developer_users | Danh sách IAM users với quyền developer | list(string) | [] | no |
