# AWS Terraform Templates

Đây là bộ sưu tập các template Terraform để triển khai hạ tầng AWS. Các template này được thiết kế để dễ dàng tùy chỉnh và sử dụng lại cho nhiều dự án.

## Cấu trúc thư mục

```
terraform-aws-templates/
│
├── base-infrastructure/      # Hạ tầng cơ sở
│   ├── vpc/                  # VPC, subnet, routing
│   ├── security/             # Security groups, NACLs
│   └── iam/                  # IAM roles, policies
│
├── compute/                  # Dịch vụ compute
│   ├── ec2/                  # EC2 instances, ASG
│   ├── ecs/                  # ECS clusters
│   └── lambda/               # Lambda functions
│
├── storage/                  # Dịch vụ lưu trữ
│   ├── s3/                   # S3 buckets
│   ├── rds/                  # RDS databases
│   └── dynamodb/             # DynamoDB tables
│
├── networking/               # Network nâng cao
│   ├── loadbalancer/         # ALB, NLB
│   ├── cloudfront/           # CloudFront distributions
│   └── route53/              # Route53 zones, records
└── ...
```

## Cách sử dụng

Mỗi thư mục chứa các Terraform module riêng biệt. Bạn có thể sử dụng chúng như sau:

1. Copy thư mục module cần thiết vào dự án của bạn
2. Tùy chỉnh các biến trong `terraform.tfvars`
3. Chạy lệnh Terraform:
   ```
   terraform init
   terraform plan
   terraform apply
   ```

Xem tài liệu chi tiết trong thư mục tương ứng để biết thêm thông tin.
