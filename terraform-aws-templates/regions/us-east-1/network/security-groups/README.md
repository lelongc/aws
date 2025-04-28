# Security Groups Module

Module này tạo các security groups thường dùng cho ứng dụng:

- Web security group (HTTP/HTTPS)
- Application security group
- Database security group (MySQL, PostgreSQL)
- Bastion host security group (SSH)
- ELB security group

## Cách sử dụng

```hcl
module "security_groups" {
  source = "../../../../regions/us-east-1/network/security-groups"

  environment = "dev"
  project     = "my-project"
  vpc_id      = module.vpc.vpc_id
  
  # Xem thêm trong variables.tf
}
```

## Outputs

Mỗi security group ID được export để sử dụng trong các module khác như EC2, RDS, ECS, etc.
