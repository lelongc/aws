# AWS Terraform Templates for Multiple Industries and Patterns

This repository contains Terraform configurations for different infrastructure patterns and business types, specifically designed for AWS Virginia region (us-east-1).

## Structure

- `modules/`: Reusable infrastructure components
  - `networking/`: VPC, subnets, route tables, etc.
- `patterns/`: Architecture patterns
  - `web-application/`: Traditional web app with EC2, ALB, ASG
  - `serverless/`: Serverless architecture with Lambda and API Gateway
- `industries/`: Industry-specific configurations
  - `ecommerce/`: E-commerce infrastructure with product database and CDN
  - `finance/`: Financial services with enhanced security and compliance features

## Usage

1. Clone this repository
2. Navigate to the pattern or industry folder that matches your needs
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Create a `terraform.tfvars` file with your specific variables
5. Apply the configuration:
   ```
   terraform apply
   ```

## Variables

Common variables across all templates:

- `environment`: Deployment environment (dev, staging, prod)
- `project_name`: Name of your project
- `vpc_cidr`: CIDR block for the VPC
- `azs`: Availability zones to use

## Customization

Each template can be customized to meet specific business requirements by modifying the corresponding `.tf` files or overriding variables.

## Security Considerations

The templates include various security features such as:

- Private subnets for sensitive resources
- Security groups with least privilege access
- Encryption for sensitive data
- WAF for web traffic filtering (Finance pattern)

Always review and adjust security settings based on your specific requirements.
