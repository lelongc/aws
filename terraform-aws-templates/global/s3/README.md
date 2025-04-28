# Global S3 Buckets

Module này tạo và quản lý các S3 bucket toàn cầu như:

- S3 bucket cho terraform state
- S3 bucket cho logging toàn hệ thống
- S3 bucket cho artifacts và backup

## Cách sử dụng

```hcl
module "global_s3" {
  source = "../../global/s3"

  environment = "dev"
  project     = "my-project"
  
  # Chi tiết xem trong variables.tf
}
```

## Outputs

| Tên | Mô tả |
|-----|--------|
| terraform_state_bucket_name | Tên của S3 bucket chứa terraform state |
| logging_bucket_name | Tên của S3 bucket chứa logs |
| artifacts_bucket_name | Tên của S3 bucket chứa artifacts |
