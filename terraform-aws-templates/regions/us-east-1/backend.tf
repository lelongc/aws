# Backend configuration - uncomment and configure after creating the S3 bucket and DynamoDB table
/*
terraform {
  backend "s3" {
    bucket         = "PROJECT_NAME-ENV-terraform-state"
    key            = "us-east-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "PROJECT_NAME-ENV-terraform-locks"
    encrypt        = true
  }
}
*/
