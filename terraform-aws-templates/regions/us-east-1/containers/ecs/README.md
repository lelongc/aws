# ECS Module

Module này tạo và quản lý ECS clusters và services:

- ECS Cluster
- ECS Services
- Task Definitions
- Auto-scaling của service
- CloudWatch Logs

## Cách sử dụng

```hcl
module "ecs" {
  source = "../../../../regions/us-east-1/containers/ecs"

  environment         = "dev"
  project             = "my-project"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  app_security_group_id = module.security_groups.app_security_group_id
  
  # Xem thêm trong variables.tf
}
```

## Outputs

| Tên | Mô tả |
|-----|--------|
| cluster_arn | ARN của ECS cluster |
| service_name | Tên của ECS service |
| task_definition_arn | ARN của task definition |
