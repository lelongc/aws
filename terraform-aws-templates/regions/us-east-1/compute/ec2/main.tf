provider "aws" {
  region = var.region
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.environment}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project}-${var.environment}-ec2-role"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Policy for EC2
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.project}-${var.environment}-ec2-policy"
  description = "Policy for EC2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.project}-${var.environment}-*",
        "arn:aws:s3:::${var.project}-${var.environment}-*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach policy to role
resource "aws_iam_policy_attachment" "ec2_attachment" {
  name       = "${var.project}-${var.environment}-ec2-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Web server
resource "aws_instance" "web" {
  count = var.web_instance_count

  ami                    = var.web_ami_id
  instance_type          = var.web_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.web_security_group_id]
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/user-data/web-server.sh")

  root_block_device {
    volume_size           = var.web_root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-web-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Role        = "web"
  }
}

# Bastion host
resource "aws_instance" "bastion" {
  count = var.enable_bastion ? 1 : 0

  ami                    = var.bastion_ami_id
  instance_type          = var.bastion_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_security_group_id]
  subnet_id              = var.public_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/user-data/bastion.sh")

  root_block_device {
    volume_size           = var.bastion_root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-bastion"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Role        = "bastion"
  }
}

# App server
resource "aws_instance" "app" {
  count = var.app_instance_count

  ami                    = var.app_ami_id
  instance_type          = var.app_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.app_security_group_id]
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/user-data/app-server.sh")

  root_block_device {
    volume_size           = var.app_root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-app-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Role        = "app"
  }
}
