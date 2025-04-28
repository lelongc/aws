# EC2 Instances Module

Module này tạo các EC2 instances cho các mục đích khác nhau:

- Web servers
- Application servers
- Bastion hosts
- Worker nodes

## Cách sử dụng

```hcl
module "ec2_instances" {
  source = "../../../../regions/us-east-1/compute/ec2"

  environment           = "dev"
  project               = "my-project"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  web_security_group_id = module.security_groups.web_security_group_id
  key_name              = "my-key-pair"
  
  # Xem thêm trong variables.tf
}
```

## Inputs

| Tên | Mô tả | Loại | Default | Required |
|-----|--------|------|---------|:--------:|
| environment | Môi trường (dev/staging/prod) | string | - | yes |
| project | Tên project | string | - | yes |
| vpc_id | VPC ID | string | - | yes |
| subnet_ids | List subnet IDs | list(string) | - | yes |
| web_security_group_id | Security group ID for web servers | string | - | yes |
| key_name | EC2 SSH key name | string | - | yes |
