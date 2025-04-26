provider "aws" {
  region = var.region
}

locals {
  name        = var.name
  environment = var.environment
  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# AMI for instances
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# User data for instances
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    environment = var.environment
  }
}

# Launch template
resource "aws_launch_template" "this" {
  name_prefix            = "${local.name}-lt-${local.environment}"
  image_id               = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
      encrypted             = var.root_volume_encrypted
      kms_key_id            = var.root_volume_encrypted ? var.kms_key_id : null
    }
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        Name = "${local.name}-${local.environment}"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.tags,
      {
        Name = "${local.name}-${local.environment}"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name                      = "${local.name}-asg-${local.environment}"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = var.target_group_arns
  termination_policies      = ["OldestInstance", "Default"]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      local.tags,
      {
        Name = "${local.name}-asg-${local.environment}"
      }
    )
    
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scaling policies - CPU
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${local.name}-scale-up-${local.environment}"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${local.name}-scale-down-${local.environment}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

# CloudWatch Alarms for CPU scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${local.name}-high-cpu-${local.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors EC2 instance high CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${local.name}-low-cpu-${local.environment}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors EC2 instance low CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

# IAM Role for instances
resource "aws_iam_role" "this" {
  name = "${local.name}-ec2-role-${local.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.name}-instance-profile-${local.environment}"
  role = aws_iam_role.this.name
}

# IAM Policy for SSM access
resource "aws_iam_policy" "ssm" {
  name        = "${local.name}-ssm-policy-${local.environment}"
  description = "Policy for EC2 to access SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ssm.arn
}

# Attach additional policies based on variables
resource "aws_iam_role_policy_attachment" "additional" {
  for_each = toset(var.additional_iam_policies)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
