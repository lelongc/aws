# Hướng dẫn sử dụng AWS Terraform Templates

Tài liệu này mô tả chi tiết cách sử dụng bộ templates Terraform cho AWS. Các template được tổ chức theo cấu trúc module để dễ dàng tái sử dụng và tùy chỉnh.

## Mục lục

- [Cài đặt yêu cầu](#cài-đặt-yêu-cầu)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Khởi tạo môi trường](#khởi-tạo-môi-trường)
- [Quy trình làm việc cơ bản](#quy-trình-làm-việc-cơ-bản)
- [Quản lý nhiều môi trường](#quản-lý-nhiều-môi-trường)
- [Module Reference](#module-reference)
  - [Network Modules](#network-modules)
  - [Compute Modules](#compute-modules)
  - [Database Modules](#database-modules)
  - [Container Modules](#container-modules)
  - [Storage Modules](#storage-modules)
  - [Security Modules](#security-modules)
  - [Serverless Modules](#serverless-modules)
  - [Monitoring Modules](#monitoring-modules)
- [CI/CD Integration](#cicd-integration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Cài đặt yêu cầu

Trước khi bắt đầu, hãy cài đặt những công cụ sau:

1. **Terraform** (phiên bản 1.0.0 trở lên)
   ```bash
   wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip
   unzip terraform_1.5.5_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. **AWS CLI** (phiên bản 2)
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

3. **Cấu hình AWS**
   ```bash
   aws configure
   ```

## Cấu trúc dự án

Dự án được tổ chức theo mô hình module, phân tách theo chức năng và môi trường:
aws-infrastructure/
├── accounts/          # Cấu hình theo môi trường triển khai
│   ├── production/    # Môi trường production
│   ├── staging/       # Môi trường staging
│   └── development/   # Môi trường development
│
├── global/            # Tài nguyên AWS global (không theo region)
│   ├── iam/           # Cấu hình IAM (users, roles, policies)
│   ├── s3/            # Global S3 buckets (logs, Terraform state)
│   ├── route53/       # DNS configurations
│   └── cloudtrail/    # Audit và logging
│
├── regions/           # Tài nguyên theo region
│   └── us-east-1/     # Region Virginia
│       ├── network/   # VPC, subnets, security groups...
│       ├── compute/   # EC2, ASG, Load Balancers...
│       ├── containers/# ECR, ECS, EKS...
│       ├── databases/ # RDS, DynamoDB, ElastiCache...
│       ├── storage/   # S3, EFS, EBS...
│       ├── serverless/# Lambda, API Gateway, Step Functions...
│       ├── security/  # WAF, Shield, KMS...
│       └── monitoring/# CloudWatch, SNS, EventBridge...
│
├── modules/           # Shared modules (tái sử dụng)
│   ├── vpc/
│   └── ec2-instance/
│
├── config/            # Các file cấu hình
│   ├── dev/
│   ├── staging/
│   └── prod/
│
└── scripts/           # Scripts automation

Tôi sẽ đơn giản hóa README.md hiện tại và tạo một file hướng dẫn chi tiết về cách sử dụng các module Terraform.

### Sửa file README.md

```markdown
# AWS Terraform Templates

Đây là bộ sưu tập các template Terraform để triển khai hạ tầng AWS. Các template này được thiết kế để dễ dàng tùy chỉnh và sử dụng lại cho nhiều dự án.

## Cấu trúc thư mục

```
aws-infrastructure/
├── accounts/          # Cấu hình cho từng môi trường (production, staging, development)
├── global/            # Tài nguyên toàn cầu (IAM, Route53, CloudTrail, S3)
├── regions/           # Tài nguyên theo region (us-east-1, ap-southeast-1, v.v.)
├── modules/           # Các module dùng chung
├── config/            # Các file cấu hình cho từng môi trường
├── scripts/           # Scripts hỗ trợ quản lý và triển khai
└── cicd/              # Cấu hình CI/CD (Jenkins, GitHub Actions, CodeBuild)
```

## Bắt đầu nhanh

```bash
# Clone repository
git clone https://github.com/your-org/aws-terraform-templates.git

# Khởi tạo môi trường dev
cd aws-terraform-templates
./scripts/init.sh dev us-east-1

# Lên kế hoạch triển khai
./scripts/plan.sh dev us-east-1

# Triển khai hạ tầng
./scripts/apply.sh dev us-east-1
```

## Tài liệu

Để biết thêm chi tiết về cách sử dụng các template, vui lòng xem [USAGE.md](./USAGE.md).

## Đóng góp

Vui lòng xem [CONTRIBUTING.md](./CONTRIBUTING.md) để biết thêm chi tiết về quy trình đóng góp mã nguồn.

## Giấy phép

Dự án này được phân phối theo giấy phép MIT. Xem tệp `LICENSE` để biết thêm thông tin.
```

### Tạo file hướng dẫn chi tiết

```markdown


Made changes.

# Hướng dẫn sử dụng AWS Terraform Templates

Tài liệu này mô tả chi tiết cách sử dụng bộ templates Terraform cho AWS. Các template được tổ chức theo cấu trúc module để dễ dàng tái sử dụng và tùy chỉnh.

## Mục lục

- [Cài đặt yêu cầu](#cài-đặt-yêu-cầu)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Khởi tạo môi trường](#khởi-tạo-môi-trường)
- [Quy trình làm việc cơ bản](#quy-trình-làm-việc-cơ-bản)
- [Quản lý nhiều môi trường](#quản-lý-nhiều-môi-trường)
- [Module Reference](#module-reference)
  - [Network Modules](#network-modules)
  - [Compute Modules](#compute-modules)
  - [Database Modules](#database-modules)
  - [Container Modules](#container-modules)
  - [Storage Modules](#storage-modules)
  - [Security Modules](#security-modules)
  - [Serverless Modules](#serverless-modules)
  - [Monitoring Modules](#monitoring-modules)
- [CI/CD Integration](#cicd-integration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Cài đặt yêu cầu

Trước khi bắt đầu, hãy cài đặt những công cụ sau:

1. **Terraform** (phiên bản 1.0.0 trở lên)
   ```bash
   wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip
   unzip terraform_1.5.5_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. **AWS CLI** (phiên bản 2)
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

3. **Cấu hình AWS**
   ```bash
   aws configure
   ```

## Cấu trúc dự án

Dự án được tổ chức theo mô hình module, phân tách theo chức năng và môi trường:

```
aws-infrastructure/
├── accounts/          # Cấu hình theo môi trường triển khai
│   ├── production/    # Môi trường production
│   ├── staging/       # Môi trường staging
│   └── development/   # Môi trường development
│
├── global/            # Tài nguyên AWS global (không theo region)
│   ├── iam/           # Cấu hình IAM (users, roles, policies)
│   ├── s3/            # Global S3 buckets (logs, Terraform state)
│   ├── route53/       # DNS configurations
│   └── cloudtrail/    # Audit và logging
│
├── regions/           # Tài nguyên theo region
│   └── us-east-1/     # Region Virginia
│       ├── network/   # VPC, subnets, security groups...
│       ├── compute/   # EC2, ASG, Load Balancers...
│       ├── containers/# ECR, ECS, EKS...
│       ├── databases/ # RDS, DynamoDB, ElastiCache...
│       ├── storage/   # S3, EFS, EBS...
│       ├── serverless/# Lambda, API Gateway, Step Functions...
│       ├── security/  # WAF, Shield, KMS...
│       └── monitoring/# CloudWatch, SNS, EventBridge...
│
├── modules/           # Shared modules (tái sử dụng)
│   ├── vpc/
│   └── ec2-instance/
│
├── config/            # Các file cấu hình
│   ├── dev/
│   ├── staging/
│   └── prod/
│
└── scripts/           # Scripts automation
```

## Khởi tạo môi trường

### 1. Tạo S3 bucket và DynamoDB table cho Terraform state

Trước khi sử dụng templates này, bạn cần tạo bucket S3 và bảng DynamoDB để lưu trữ Terraform state:

```bash
cd global/s3
terraform init
terraform apply -var="environment=dev" -var="project=your-project"
```

### 2. Cấu hình Backend

Sau khi tạo S3 bucket, cấu hình backend trong file `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-project-dev-terraform-state"
    key            = "us-east-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-project-dev-terraform-locks"
    encrypt        = true
  }
}
```

### 3. Khởi tạo dự án bằng script

```bash
./scripts/init.sh dev us-east-1
```

## Quy trình làm việc cơ bản

### 1. Plan

```bash
./scripts/plan.sh dev us-east-1
```

### 2. Apply

```bash
./scripts/apply.sh dev us-east-1
```

### 3. Destroy

```bash
./scripts/destroy.sh dev us-east-1
```

## Quản lý nhiều môi trường

Mỗi môi trường (dev, staging, production) có thư mục cấu hình riêng trong thư mục `config/`. Để chuyển đổi giữa các môi trường:

```bash
# Triển khai cho môi trường development
./scripts/apply.sh dev us-east-1

# Triển khai cho môi trường staging
./scripts/apply.sh staging us-east-1

# Triển khai cho môi trường production
./scripts/apply.sh prod us-east-1
```

## Module Reference

### Network Modules

#### VPC Module

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name            = "${var.project}-${var.environment}"
  vpc_cidr_block  = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
```

#### Security Groups

```hcl
module "security_groups" {
  source = "./regions/us-east-1/network/security-groups"

  environment = var.environment
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  
  web_ingress_cidr_blocks = ["0.0.0.0/0"]
  app_port = 8080
}
```

### Compute Modules

#### EC2 Instances

```hcl
module "app_server" {
  source = "../../modules/ec2-instance"
  
  name           = "${var.project}-${var.environment}-app"
  instance_count = 2
  
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.micro"
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.security_groups.app_security_group_id]
  subnet_id              = module.vpc.private_subnet_ids[0]
  
  user_data = file("./regions/us-east-1/compute/ec2/user-data/app-server.sh")
  
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
```

#### Auto Scaling Groups

```hcl
module "asg" {
  source = "./regions/us-east-1/compute/auto-scaling"
  
  environment  = var.environment
  project      = var.project
  
  image_id     = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  key_name     = var.key_name
  
  security_group_ids = [module.security_groups.app_security_group_id]
  subnet_ids        = module.vpc.private_subnet_ids
  
  min_size         = 2
  max_size         = 10
  desired_capacity = 2
  
  target_group_arns = [module.load_balancers.target_group_arn]
}
```

### Database Modules

#### RDS Database

```hcl
module "rds" {
  source = "./regions/us-east-1/databases/rds"
  
  environment = var.environment
  project     = var.project
  
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id
  
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.small"
  allocated_storage = 20
  db_name           = "appdb"
  db_username       = "admin"
  
  multi_az               = false
  backup_retention_period = 7
  deletion_protection    = false
}
```

#### DynamoDB Tables

```hcl
module "dynamodb" {
  source = "./regions/us-east-1/databases/dynamodb"
  
  environment = var.environment
  project     = var.project
  
  tables = [
    {
      name         = "users"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "id"
      attributes = [
        {
          name = "id"
          type = "S"
        }
      ]
    }
  ]
}
```

### Container Modules

#### ECS Cluster & Service

```hcl
module "ecs" {
  source = "./regions/us-east-1/containers/ecs"
  
  environment = var.environment
  project     = var.project
  
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_security_group_id = module.security_groups.app_security_group_id
  
  app_container_image = "${var.ecr_repository_url}:latest"
  app_container_port  = 8080
  
  app_target_group_arn = module.load_balancers.target_group_arn
  auto_scaling_group_arn = module.asg.autoscaling_group_arn
  
  app_environment_vars = {
    DB_HOST = module.rds.db_instance_address
    DB_NAME = module.rds.db_name
  }
}
```

### CI/CD Integration

#### Jenkins Pipeline

Jenkinsfile được cung cấp để tự động hóa việc triển khai Terraform:

```groovy
pipeline {
    agent any
    
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Select environment')
        choice(name: 'REGION', choices: ['us-east-1', 'eu-west-1'], description: 'Select AWS region')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Init') {
            steps {
                sh './scripts/init.sh ${ENVIRONMENT} ${REGION}'
            }
        }
        
        stage('Plan') {
            steps {
                sh './scripts/plan.sh ${ENVIRONMENT} ${REGION}'
            }
        }
        
        stage('Apply/Destroy') {
            when {
                expression { params.ACTION == 'apply' || params.ACTION == 'destroy' }
            }
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh './scripts/apply.sh ${ENVIRONMENT} ${REGION}'
                    } else {
                        sh './scripts/destroy.sh ${ENVIRONMENT} ${REGION}'
                    }
                }
            }
        }
    }
}
```

#### GitHub Actions

File workflow cho GitHub Actions cũng đã có sẵn trong `cicd/github-actions/terraform.yml`.

## Best Practices

1. **Mô-đun hóa**: Tách các thành phần thành các module riêng biệt, có thể tái sử dụng
2. **Quản lý state**: Sử dụng S3 + DynamoDB backend để quản lý Terraform state an toàn
3. **Tham số hóa**: Sử dụng biến cho các giá trị cấu hình thay vì hard-coding
4. **Quản lý môi trường**: Sử dụng các tfvars files khác nhau cho mỗi môi trường
5. **CICD**: Tự động hóa việc triển khai bằng Jenkins hoặc GitHub Actions
6. **Kiểm tra**: Sử dụng `terraform validate` và `terraform fmt` để đảm bảo chất lượng mã

## Troubleshooting

### State Lock Issues

Nếu gặp lỗi state lock:

```bash
# Kiểm tra và xóa lock nếu cần
aws dynamodb get-item \
  --table-name your-project-dev-terraform-locks \
  --key '{"LockID": {"S": "your-project-dev/us-east-1/terraform.tfstate"}}'

aws dynamodb delete-item \
  --table-name your-project-dev-terraform-locks \
  --key '{"LockID": {"S": "your-project-dev/us-east-1/terraform.tfstate"}}'
```

### Access Denied

Nếu gặp lỗi AWS permissions:

```bash
# Xác minh thông tin đăng nhập AWS
aws sts get-caller-identity
```

### Module Import Errors

Nếu gặp lỗi khi import module:

```
# Đảm bảo đường dẫn module chính xác
terraform get -update
```

