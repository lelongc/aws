# AWS Terraform Templates

Đây là bộ sưu tập các template Terraform để triển khai hạ tầng AWS. Các template này được thiết kế để dễ dàng tùy chỉnh và sử dụng lại cho nhiều dự án.

## Cấu trúc thư mục

```
aws-infrastructure/
├── .gitignore                         # Loại trừ các file như .tfstate, .terraform/, etc.
├── README.md                          # Hướng dẫn sử dụng và tài liệu dự án
│
├── accounts/                          # Phân tách theo tài khoản AWS
│   ├── production/
│   │   └── main.tf                    # Import các module cho môi trường production
│   ├── staging/
│   │   └── main.tf                    # Import các module cho môi trường staging
│   └── development/
│       └── main.tf                    # Import các module cho môi trường development
│
├── global/                            # Tài nguyên global (không phụ thuộc region)
│   ├── iam/                           # Identity & Access Management
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── policies/                  # Tệp JSON cho các policy IAM
│   │       ├── assume-role-policy.json
│   │       └── permissions-policy.json
│   ├── s3/                            # S3 buckets cho logging, tfstate, etc.
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── route53/                       # DNS configurations
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── cloudtrail/                    # Logging và Audit
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── regions/
│   └── us-east-1/                     # Region Virginia
│       ├── main.tf                    # Import modules cho region
│       ├── provider.tf                # Cấu hình provider cho us-east-1
│       ├── variables.tf               # Variables cho region
│       ├── outputs.tf                 # Outputs từ region
│       ├── backend.tf                 # Backend configuration (S3 + DynamoDB)
│       │
│       ├── network/                   # Infrastructure mạng
│       │   ├── vpc/
│       │   │   ├── main.tf            # VPC definition
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── subnets/
│       │   │   ├── main.tf            # Public và private subnets
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── security-groups/
│       │   │   ├── main.tf            # Security groups
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── nat-gateway/
│       │   │   ├── main.tf
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── transit-gateway/
│       │       ├── main.tf            # Transit gateway cho kết nối multi-VPC
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── compute/
│       │   ├── ec2/
│       │   │   ├── main.tf            # EC2 instances
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   └── user-data/         # Scripts khởi động EC2
│       │   │       ├── app-server.sh
│       │   │       └── bastion.sh
│       │   ├── auto-scaling/
│       │   │   ├── main.tf            # Auto-scaling groups
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── load-balancers/
│       │       ├── main.tf            # ALB và NLB
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── containers/
│       │   ├── ecr/
│       │   │   ├── main.tf            # Container registries
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── ecs/
│       │   │   ├── main.tf            # ECS clusters và services
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   └── task-definitions/  # ECS task definitions
│       │   │       ├── app.json
│       │   │       └── worker.json
│       │   └── eks/
│       │       ├── main.tf            # Kubernetes clusters
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── databases/
│       │   ├── rds/
│       │   │   ├── main.tf            # RDS instances
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── dynamodb/
│       │   │   ├── main.tf            # DynamoDB tables
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── elasticache/
│       │   │   ├── main.tf            # Redis/Memcached clusters
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── aurora/
│       │       ├── main.tf            # Aurora clusters
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── storage/
│       │   ├── s3-regional/
│       │   │   ├── main.tf            # Regional S3 buckets
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── efs/
│       │   │   ├── main.tf            # Elastic File System
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── ebs/
│       │       ├── main.tf            # EBS volumes
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── serverless/
│       │   ├── lambda/
│       │   │   ├── main.tf            # Lambda functions
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   └── functions/         # Lambda code
│       │   │       ├── api-handler/
│       │   │       └── event-processor/
│       │   ├── api-gateway/
│       │   │   ├── main.tf            # API Gateway
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── step-functions/
│       │       ├── main.tf            # Step Functions
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       ├── security/
│       │   ├── waf/
│       │   │   ├── main.tf            # WAF configurations
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── shield/
│       │   │   ├── main.tf            # DDoS protection
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── kms/
│       │   │   ├── main.tf            # Encryption keys
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── secrets-manager/
│       │       ├── main.tf            # Secrets
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       └── monitoring/
│           ├── cloudwatch/
│           │   ├── main.tf            # CloudWatch alarms và dashboards
│           │   ├── variables.tf
│           │   └── outputs.tf
│           ├── sns/
│           │   ├── main.tf            # SNS topics
│           │   ├── variables.tf
│           │   └── outputs.tf
│           └── eventbridge/
│               ├── main.tf            # EventBridge rules
│               ├── variables.tf
│               └── outputs.tf
│
├── modules/                           # Shared modules cho toàn bộ dự án
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2-instance/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ... (các module khác)
│
├── config/                           # Các file cấu hình
│   ├── dev/
│   │   ├── us-east-1.tfvars         # Biến cho dev trong us-east-1
│   │   └── backend-dev.hcl          # Cấu hình backend cho dev
│   ├── staging/
│   │   ├── us-east-1.tfvars         # Biến cho staging trong us-east-1
│   │   └── backend-staging.hcl      # Cấu hình backend cho staging
│   └── prod/
│       ├── us-east-1.tfvars         # Biến cho production trong us-east-1
│       └── backend-prod.hcl         # Cấu hình backend cho production
│
├── scripts/                          # Scripts hỗ trợ
│   ├── init.sh                       # Initialize Terraform
│   ├── plan.sh                       # Run plans với các tham số chuẩn
│   ├── apply.sh                      # Apply với safety checks
│   ├── destroy.sh                    # Clean up resources
│   └── validate.sh                   # Validate cấu hình
│
└── cicd/                             # CI/CD configuration
    ├── buildspec.yml                 # AWS CodeBuild configuration
    ├── Jenkinsfile                   # Jenkins pipeline
    └── github-actions/
        └── terraform.yml            # GitHub Actions workflow
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
