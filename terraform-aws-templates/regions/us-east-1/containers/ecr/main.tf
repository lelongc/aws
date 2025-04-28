provider "aws" {
  region = var.region
}

# ECR Repository
resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)
  
  name                 = "${var.project}-${var.environment}-${each.key}"
  image_tag_mutability = var.image_tag_mutability
  
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  
  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key != "" ? var.kms_key : null
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-${each.key}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.enable_lifecycle_policy ? toset(var.repository_names) : []
  
  repository = aws_ecr_repository.this[each.key].name
  
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Repository Policy for cross-account access
resource "aws_ecr_repository_policy" "cross_account" {
  for_each = var.cross_account_ids != null ? toset(var.repository_names) : []
  
  repository = aws_ecr_repository.this[each.key].name
  policy     = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "CrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = formatlist("arn:aws:iam::%s:root", var.cross_account_ids)
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

# Public ECR Repository (if needed)
resource "aws_ecrpublic_repository" "public" {
  for_each = toset(var.public_repository_names)
  
  repository_name = "${var.project}-${var.environment}-${each.key}"
  
  catalog_data {
    description     = "${each.key} repository for ${var.project}-${var.environment}"
    architectures   = ["x86-64", "ARM"]
    operating_systems = ["Linux"]
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-${each.key}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
