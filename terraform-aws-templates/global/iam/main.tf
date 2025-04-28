provider "aws" {
  region = var.region
}

# Admin Role
resource "aws_iam_role" "admin_role" {
  name               = "${var.environment}-admin-role"
  assume_role_policy = file("${path.module}/policies/assume-role-policy.json")

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# Admin Policy Attachment
resource "aws_iam_policy_attachment" "admin_policy" {
  name       = "${var.environment}-admin-policy-attachment"
  roles      = [aws_iam_role.admin_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Developer Role
resource "aws_iam_role" "developer_role" {
  name               = "${var.environment}-developer-role"
  assume_role_policy = file("${path.module}/policies/assume-role-policy.json")

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# Developer Policy
resource "aws_iam_policy" "developer_policy" {
  name        = "${var.environment}-developer-policy"
  description = "Policy for developers"
  policy      = file("${path.module}/policies/permissions-policy.json")
}

# Developer Policy Attachment
resource "aws_iam_policy_attachment" "developer_policy" {
  name       = "${var.environment}-developer-policy-attachment"
  roles      = [aws_iam_role.developer_role.name]
  policy_arn = aws_iam_policy.developer_policy.arn
}

# Admin Group
resource "aws_iam_group" "admin_group" {
  name = "${var.environment}-admin-group"
}

# Developer Group
resource "aws_iam_group" "developer_group" {
  name = "${var.environment}-developer-group"
}

# Create Admin Users
resource "aws_iam_user" "admin_users" {
  for_each = toset(var.admin_users)
  
  name = each.value
  
  tags = {
    Environment = var.environment
    Role        = "Admin"
    Terraform   = "true"
  }
}

# Create Developer Users
resource "aws_iam_user" "developer_users" {
  for_each = toset(var.developer_users)
  
  name = each.value
  
  tags = {
    Environment = var.environment
    Role        = "Developer"
    Terraform   = "true"
  }
}

# Add Users to Groups
resource "aws_iam_user_group_membership" "admin_group_membership" {
  for_each = toset(var.admin_users)
  
  user   = each.value
  groups = [aws_iam_group.admin_group.name]
  
  depends_on = [aws_iam_user.admin_users]
}

resource "aws_iam_user_group_membership" "developer_group_membership" {
  for_each = toset(var.developer_users)
  
  user   = each.value
  groups = [aws_iam_group.developer_group.name]
  
  depends_on = [aws_iam_user.developer_users]
}
