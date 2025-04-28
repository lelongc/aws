# Load Balancers Module

Module này tạo Application Load Balancers và Network Load Balancers với:

- Target Groups
- Listeners
- Health Checks
- SSL Certificates (HTTPS)
- WAF Integration (tùy chọn)

## Cách sử dụng

```hcl
module "load_balancers" {
  source = "../../../../regions/us-east-1/compute/load-balancers"

  environment           = "dev"
  project               = "my-project"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  elb_security_group_id = module.security_groups.elb_security_group_id
  
  # Chi tiết xem trong variables.tf
}
```

## Outputs

| Tên | Mô tả |
|-----|--------|
| alb_arn | ARN của Application Load Balancer |
| alb_dns_name | DNS name của ALB |
| target_group_arns | ARNs của target groups |
