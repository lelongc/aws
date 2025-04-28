# Terraform: Hướng dẫn toàn diện từ cơ bản đến nâng cao

## Mục lục
- [1. Giới thiệu về Terraform](#1-giới-thiệu-về-terraform)
- [2. Kiến thức cơ bản](#2-kiến-thức-cơ-bản)
  - [2.1. Cài đặt Terraform](#21-cài-đặt-terraform)
  - [2.2. Cấu trúc cơ bản của một dự án Terraform](#22-cấu-trúc-cơ-bản-của-một-dự-án-terraform)
  - [2.3. Ngôn ngữ HCL cơ bản](#23-ngôn-ngữ-hcl-cơ-bản)
  - [2.4. Vòng đời Terraform](#24-vòng-đời-terraform)
- [3. Các khái niệm chính trong Terraform](#3-các-khái-niệm-chính-trong-terraform)
  - [3.1. Providers](#31-providers)
  - [3.2. Resources](#32-resources)
  - [3.3. Data Sources](#33-data-sources)
  - [3.4. Variables và Outputs](#34-variables-và-outputs)
  - [3.5. Terraform State](#35-terraform-state)
- [4. Kiến thức trung cấp](#4-kiến-thức-trung-cấp)
  - [4.1. Modules](#41-modules)
  - [4.2. Workspaces](#42-workspaces)
  - [4.3. Backend và Remote State](#43-backend-và-remote-state)
  - [4.4. Dependency Management](#44-dependency-management)
  - [4.5. Taint và Replace](#45-taint-và-replace)
- [5. Kiến thức nâng cao](#5-kiến-thức-nâng-cao)
  - [5.1. Functions và Expressions](#51-functions-và-expressions)
  - [5.2. Meta-Arguments](#52-meta-arguments)
  - [5.3. Provisioners](#53-provisioners)
  - [5.4. Terraform Cloud và Enterprise](#54-terraform-cloud-và-enterprise)
  - [5.5. Testing trong Terraform](#55-testing-trong-terraform)
- [6. Thực hành và best practices](#6-thực-hành-và-best-practices)
  - [6.1. CI/CD với Terraform](#61-cicd-với-terraform)
  - [6.2. Quản lý môi trường đa dạng](#62-quản-lý-môi-trường-đa-dạng)
  - [6.3. Security Best Practices](#63-security-best-practices)
  - [6.4. Performance Optimization](#64-performance-optimization)
- [7. Các công cụ bổ sung và tích hợp](#7-các-công-cụ-bổ-sung-và-tích-hợp)

## 1. Giới thiệu về Terraform

Terraform là công cụ Infrastructure as Code (IaC) mã nguồn mở được phát triển bởi HashiCorp. Nó cho phép người dùng xác định và cung cấp hạ tầng sử dụng ngôn ngữ cấu hình khai báo có tên là HashiCorp Configuration Language (HCL) hoặc tùy chọn JSON.

**Ưu điểm chính của Terraform:**
- **Đa nền tảng**: Hỗ trợ nhiều nhà cung cấp cloud và dịch vụ (AWS, Azure, GCP, Kubernetes, v.v.)
- **Khai báo**: Mã mô tả trạng thái cuối cùng mong muốn của hạ tầng
- **Quản lý trạng thái**: Theo dõi tài nguyên thực tế và đồng bộ hóa với cấu hình
- **Plan trước khi Apply**: Xem trước các thay đổi trước khi thực hiện
- **Graph các phụ thuộc**: Tự động xác định thứ tự tạo/hủy tài nguyên

## 2. Kiến thức cơ bản

### 2.1. Cài đặt Terraform

**Linux/MacOS với Homebrew:**
```bash
brew install terraform
```

**Windows với Chocolatey:**
```bash
choco install terraform
```

**Kiểm tra cài đặt:**
```bash
terraform version
```

### 2.2. Cấu trúc cơ bản của một dự án Terraform

Một dự án Terraform thường có cấu trúc:
```
project/
├── main.tf          # Cấu hình chính
├── variables.tf     # Khai báo biến đầu vào
├── outputs.tf       # Khai báo output
├── terraform.tfvars # Giá trị biến (không nên commit lên git)
└── versions.tf      # Yêu cầu phiên bản provider/terraform
```

### 2.3. Ngôn ngữ HCL cơ bản

**Khai báo resource:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "example-instance"
    Environment = "dev"
  }
}
```

**Khai báo biến:**
```hcl
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}
```

**References và expressions:**
```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.environment == "prod" ? "t2.medium" : "t2.micro"
}
```

### 2.4. Vòng đời Terraform

Quy trình làm việc cơ bản với Terraform:

1. **Init**: Khởi tạo thư mục làm việc, tải providers/modules
   ```bash
   terraform init
   ```

2. **Plan**: Tạo kế hoạch thực thi, xem trước thay đổi
   ```bash
   terraform plan
   ```

3. **Apply**: Thực hiện thay đổi trên hạ tầng thực
   ```bash
   terraform apply
   ```

4. **Destroy**: Xóa tất cả tài nguyên đã tạo
   ```bash
   terraform destroy
   ```

## 3. Các khái niệm chính trong Terraform

### 3.1. Providers

Providers là cầu nối giữa Terraform và các API bên ngoài (AWS, Azure, v.v.):

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

Một cấu hình có thể sử dụng nhiều providers:

```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

resource "aws_instance" "example" {
  provider = aws.west
  # ...
}
```

### 3.2. Resources

Resources là thành phần chính để khai báo tài nguyên cần quản lý:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

**Tham chiếu giữa các resources:**
```hcl
resource "aws_instance" "web" {
  # ...
}

resource "aws_eip" "ip" {
  instance = aws_instance.web.id
}
```

### 3.3. Data Sources

Data Sources cho phép Terraform sử dụng thông tin về tài nguyên đã tồn tại:

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
```

### 3.4. Variables và Outputs

**Khai báo biến đầu vào:**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
  
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Instance type must be t2.micro or t3.micro."
  }
}
```

**Khai báo output:**
```hcl
output "instance_ip_addr" {
  value       = aws_instance.web.public_ip
  description = "Public IP address of the web server"
  sensitive   = false
}
```

**Sử dụng biến từ file:**
```
# terraform.tfvars
instance_type = "t3.micro"
region = "eu-west-1"
```

### 3.5. Terraform State

State là file quan trọng lưu trữ mapping giữa tài nguyên trong cấu hình và thế giới thực:

**Các lệnh làm việc với state:**
```bash
terraform state list
terraform state show aws_instance.web
terraform state mv aws_instance.web aws_instance.backend
terraform state rm aws_instance.web
terraform state pull > backup.tfstate
```

## 4. Kiến thức trung cấp

### 4.1. Modules

Modules giúp tổ chức, đóng gói và tái sử dụng cấu hình Terraform:

**Cấu trúc một module:**
```
modules/vpc/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

**Sử dụng module:**
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  region     = var.region
}

resource "aws_instance" "app" {
  subnet_id = module.vpc.public_subnet_id
  # ...
}
```

**Module từ Terraform Registry:**
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  # ...
}
```

### 4.2. Workspaces

Workspaces cho phép quản lý nhiều môi trường với cùng một cấu hình:

```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform workspace list
```

**Sử dụng workspace trong cấu hình:**
```hcl
resource "aws_instance" "example" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
  
  tags = {
    Environment = terraform.workspace
  }
}
```

### 4.3. Backend và Remote State

Backends xác định nơi lưu trữ và cách truy xuất state:

**S3 Backend:**
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "myproject/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

**Remote State Data Source:**
```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-states"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
}
```

### 4.4. Dependency Management

Terraform tự động xác định phụ thuộc dựa trên tài nguyên tham chiếu đến nhau:

**Explicit Dependencies:**
```hcl
resource "aws_instance" "web" {
  # ...
  depends_on = [aws_iam_role_policy.web_policy]
}
```

**Implicit Dependencies:**
```hcl
resource "aws_instance" "web" {
  subnet_id = aws_subnet.main.id  # Implicit dependency
}
```

### 4.5. Taint và Replace

Đánh dấu tài nguyên để tạo lại trong lần apply tiếp theo:

```bash
terraform taint aws_instance.web
```

Trong Terraform 0.15.2+:
```bash
terraform apply -replace="aws_instance.web"
```

## 5. Kiến thức nâng cao

### 5.1. Functions và Expressions

HCL hỗ trợ nhiều hàm và biểu thức để xử lý dữ liệu:

**String Functions:**
```hcl
locals {
  upper_name = upper(var.name)
  project    = format("%s-%s", var.project, var.environment)
}
```

**Collection Functions:**
```hcl
locals {
  instance_ids = [for i in aws_instance.web : i.id]
  
  instances_by_az = {
    for instance in aws_instance.web :
    instance.availability_zone => instance.id...
  }
}
```

**Numeric Functions:**
```hcl
locals {
  max_instances = min(var.desired_instances, 10)
}
```

**Conditional Expressions:**
```hcl
resource "aws_instance" "web" {
  instance_type = var.environment == "prod" ? "m5.large" : "t3.small"
  
  count = var.enabled ? var.instance_count : 0
}
```

### 5.2. Meta-Arguments

Các meta-argument áp dụng trên nhiều loại tài nguyên:

**Count:**
```hcl
resource "aws_instance" "server" {
  count = 4
  
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  
  tags = {
    Name = "Server ${count.index + 1}"
  }
}
```

**For Each:**
```hcl
resource "aws_iam_user" "users" {
  for_each = toset(["john", "mary", "bob"])
  
  name = each.key
}
```

**Provider:**
```hcl
resource "aws_instance" "foo" {
  provider = aws.west
  # ...
}
```

**Lifecycle:**
```hcl
resource "aws_instance" "web" {
  # ...
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
  }
}
```

### 5.3. Provisioners

Provisioners thực hiện các hành động trên tài nguyên sau khi tạo:

```hcl
resource "aws_instance" "web" {
  # ...
  
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

**Lưu ý**: HashiCorp khuyên dùng các công cụ dedicated như Ansible, Chef hoặc Puppet thay vì provisioners khi có thể.

### 5.4. Terraform Cloud và Enterprise

Terraform Cloud/Enterprise cung cấp:
- Remote execution
- Shared state management
- Private module registry
- Policy as Code (Sentinel)
- Team collaboration
- VCS integration

**Cấu hình Cloud:**
```hcl
terraform {
  cloud {
    organization = "my-org"
    
    workspaces {
      name = "my-app-prod"
    }
  }
}
```

### 5.5. Testing trong Terraform

Các phương pháp test Terraform code:

**Terratest** - Thư viện Go để test infrastructure:
```go
package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsExample(t *testing.T) {
  terraformOptions := &terraform.Options{
    TerraformDir: "../examples/aws",
    Vars: map[string]interface{}{
      "region": "us-west-2",
    },
  }
  
  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)
  
  // Validate outputs
  instanceID := terraform.Output(t, terraformOptions, "instance_id")
  // Assert instanceID is not empty
}
```

**Kitchen-Terraform** - Test framework dựa trên Ruby:
```ruby
driver:
  name: terraform

provisioner:
  name: terraform

verifier:
  name: terraform
  systems:
    - name: aws
      backend: aws
      controls:
        - vpc_check
      
platforms:
  - name: aws

suites:
  - name: default
```

## 6. Thực hành và best practices

### 6.1. CI/CD với Terraform

**GitLab CI Pipeline:**
```yaml
stages:
  - validate
  - plan
  - apply

validate:
  stage: validate
  script:
    - terraform init -backend=false
    - terraform validate
    - terraform fmt -check

plan:
  stage: plan
  script:
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - tfplan

apply:
  stage: apply
  script:
    - terraform apply -auto-approve tfplan
  when: manual
  only:
    - main
```

### 6.2. Quản lý môi trường đa dạng

**Cách tiếp cận với directories:**
```
environments/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    ├── variables.tf
    └── terraform.tfvars
```

**Sử dụng Terragrunt:**
```hcl
# terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//vpc"
}

inputs = {
  vpc_cidr = "10.0.0.0/16"
  environment = "dev"
}
```

### 6.3. Security Best Practices

- Sử dụng Terraform Vault provider để quản lý secrets
- Lưu trữ state trong backend có mã hóa
- Giới hạn quyền của IAM role dùng cho CI/CD
- Dùng tfsec để quét lỗ hổng bảo mật
- Sử dụng biến nhạy cảm với marker `sensitive = true`
- Dùng Terraform Sentinel để thực thi policy

**Ví dụ với tfsec:**
```bash
# Cài đặt
brew install tfsec

# Chạy scan
tfsec .
```

### 6.4. Performance Optimization

- Sử dụng `-parallelism=n` để điều chỉnh số tài nguyên tạo song song
- Chia nhỏ state với nhiều workspaces hoặc directories
- Sử dụng `-target` để áp dụng thay đổi cụ thể
- Tối ưu module để giảm số lượng API calls

## 7. Các công cụ bổ sung và tích hợp

- **Terragrunt**: Wrapper cung cấp cấu hình DRY và tính năng bổ sung
- **Terraform CDK**: Định nghĩa infrastructure bằng TypeScript/Python thay vì HCL
- **Atlantis**: Tự động hóa Terraform Plan/Apply thông qua GitHub pull requests
- **Infracost**: Ước tính chi phí cloud dựa trên cấu hình Terraform
- **Checkov**: Phân tích tĩnh mã Terraform cho vấn đề bảo mật và compliance
- **Terraform Docs**: Tự động tạo tài liệu từ mã Terraform

**Ví dụ với infracost:**
```bash
# Cài đặt
brew install infracost

# Ước tính chi phí
infracost breakdown --path .
```

---

Tài liệu này cung cấp tổng quan về Terraform từ cơ bản đến nâng cao. Để tìm hiểu chi tiết, vui lòng tham khảo [tài liệu chính thức của HashiCorp](https://www.terraform.io/docs).
