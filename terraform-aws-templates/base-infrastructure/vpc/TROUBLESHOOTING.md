# Khắc phục sự cố với VPC Module

Tài liệu này cung cấp các hướng dẫn để giải quyết các vấn đề thường gặp khi sử dụng module VPC.

## Lỗi phổ biến và cách khắc phục

### 1. Lỗi giới hạn quotas của AWS

**Lỗi:**

```
Error: Error creating VPC: VpcLimitExceeded: The maximum number of VPCs has been reached.
```

**Giải pháp:**

- Kiểm tra [Service Quotas](https://console.aws.amazon.com/servicequotas/) trong AWS Console
- Yêu cầu tăng giới hạn số lượng VPC (mặc định là 5 VPC mỗi region)
- Xóa VPC không sử dụng

### 2. Lỗi CIDR block trùng lặp

**Lỗi:**

```
Error: Error creating VPC: InvalidVpc.Range: The CIDR '10.0.0.0/16' conflicts with another VPC
```

**Giải pháp:**

- Sử dụng CIDR block khác cho VPC
- Kiểm tra các VPC hiện có để tránh xung đột địa chỉ

### 3. Lỗi khi tạo Internet Gateway

**Lỗi:**

```
Error: Error attaching internet gateway: InvalidParameterValue: internetGatewayID is invalid
```

**Giải pháp:**

- Kiểm tra quyền IAM có đủ để tạo Internet Gateway
- Xác nhận VPC đã được tạo thành công trước khi gắn Internet Gateway

### 4. Lỗi khi xóa VPC

**Lỗi:**

```
Error: Error deleting VPC: DependencyViolation: The vpc 'vpc-123456' has dependencies and cannot be deleted.
```

**Giải pháp:**

- Đảm bảo đã xóa tất cả resource phụ thuộc (EC2, RDS, ELB, etc.)
- Thứ tự xóa các resource:
  1. EC2 instances, RDS, ElastiCache
  2. ELB và các network interface
  3. NAT Gateway
  4. VPC Endpoints
  5. Security Groups
  6. Network ACLs
  7. Subnets
  8. Route Tables
  9. Internet Gateway
  10. Cuối cùng là VPC

### 5. NAT Gateway không hoạt động

**Triệu chứng:**

- EC2 instances trong private subnet không thể kết nối internet

**Giải pháp:**

- Kiểm tra route tables của private subnet có route đến NAT Gateway không
- Xác nhận NAT Gateway được gắn vào public subnet với internet access
- Kiểm tra Security Groups cho phép outbound traffic
- Kiểm tra status của NAT Gateway trong AWS Console

## Vấn đề với các route

### 1. Route tables không áp dụng đúng

**Triệu chứng:**

- Traffic không đi theo đường mong muốn

**Giải pháp:**

- Kiểm tra associations của route tables với subnets
- Sử dụng AWS Console để xác thực route table associations

```
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<vpc-id>"
```

### 2. VPC Endpoints không hoạt động

**Triệu chứng:**

- Không thể kết nối đến S3 hoặc DynamoDB từ private subnet khi đã tạo Endpoint

**Giải pháp:**

- Kiểm tra route tables của subnet chứa endpoint
- Xác nhận security group cho phép traffic đến endpoints
- Kiểm tra DNS settings: `enable_dns_hostnames` và `enable_dns_support` nên được đặt là `true`

## Kiểm tra kết nối mạng

Sử dụng các lệnh sau để kiểm tra kết nối mạng:

### 1. Kiểm tra Internet Gateway

```bash
# Kiểm tra từ EC2 instance trong public subnet
ping 8.8.8.8
curl https://checkip.amazonaws.com
```

### 2. Kiểm tra NAT Gateway

```bash
# Kiểm tra từ EC2 instance trong private subnet
ping 8.8.8.8
curl https://checkip.amazonaws.com
```

### 3. Kiểm tra VPC Endpoints

```bash
# Kiểm tra S3 endpoint từ EC2 instance trong private subnet
aws s3 ls --region <your-region>

# Kiểm tra DynamoDB endpoint
aws dynamodb list-tables --region <your-region>
```

## Logging và Monitoring

### 1. VPC Flow Logs

Bật VPC Flow Logs để debug network issues:

```hcl
module "vpc" {
  source = "./terraform-aws-templates/base-infrastructure/vpc"

  # ... các biến khác

  enable_flow_log = true
  # Xác định thêm các tùy chọn flow log nếu cần
}
```

### 2. CloudWatch Metrics

Giám sát NAT Gateway:

- `NATGateway` namespace trong CloudWatch
- Metrics: `BytesInFromDestination`, `BytesInFromSource`, `BytesOutToDestination`, `BytesOutToSource`

## Làm việc với Terraform

### 1. Bật verbose logging

```bash
export TF_LOG=DEBUG
terraform apply
```

### 2. Kiểm tra Terraform state

```bash
terraform state list
terraform state show 'module.vpc.aws_vpc.this'
```

### 3. Target apply

```bash
terraform apply -target=module.vpc
```

### 4. Sửa chữa state khi có xung đột

```bash
terraform import module.vpc.aws_vpc.this <vpc-id>
terraform import module.vpc.aws_subnet.public[0] <subnet-id>
```

## Liên hệ hỗ trợ

Nếu bạn không thể giải quyết vấn đề:

1. Kiểm tra [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
2. Tạo issue trên repository với log chi tiết và mô tả vấn đề
3. Liên hệ AWS Support nếu nghi vấn đề liên quan đến AWS service limits hoặc bugs
