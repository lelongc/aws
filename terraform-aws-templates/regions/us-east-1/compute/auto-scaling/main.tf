provider "aws" {
  region = var.region
}

# Launch Template
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.environment}-"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  iam_instance_profile {
    name = var.instance_profile_name
  }
  
  network_interfaces {
    security_groups             = var.security_group_ids
    associate_public_ip_address = var.associate_public_ip_address
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"
    
    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }
  
  user_data = var.user_data_base64
  
  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name        = "${var.project}-${var.environment}-instance"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    }, var.tags)
  }
  
  tags = merge({
    Name        = "${var.project}-${var.environment}-launch-template"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }, var.tags)
}

# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-${var.environment}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  
  target_group_arns         = var.target_group_arns
  
  lifecycle {
    create_before_destroy = true
  }
  
  # Use dynamic tagging
  dynamic "tag" {
    for_each = merge(
      {
        Name        = "${var.project}-${var.environment}"
        Environment = var.environment
        Project     = var.project
        Terraform   = "true"
      },
      var.tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Scale-up Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-${var.environment}-scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

# Scale-down Policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-${var.environment}-scale-down-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# CloudWatch CPU Alarm for Scale-up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  alarm_description   = "Scale up if CPU utilization is above ${var.scale_up_threshold}% for 5 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

# CloudWatch CPU Alarm for Scale-down
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project}-${var.environment}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  alarm_description   = "Scale down if CPU utilization is below ${var.scale_down_threshold}% for 5 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}
