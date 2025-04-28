# RDS Module

Module này tạo database RDS (MySQL/PostgreSQL) với các tùy chọn cao cấp:

- Multi-AZ cho high availability
- Backup và retention
- Encryption
- Monitoring với CloudWatch
- Parameter groups tùy chỉnh

## Cách sử dụng

```hcl
module "rds" {
  source = "../../../../regions/us-east-1/databases/rds"

  environment         = "dev"
  project             = "my-project"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id
  
  # Xem thêm trong variables.tf
}
```

## Outputs

| Tên | Mô tả |
|-----|--------|
| db_instance_endpoint | Endpoint của database instance |
| db_instance_id | ID của database instance |
