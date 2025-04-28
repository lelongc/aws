provider "aws" {
  region = var.region
}

# Create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.elb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = 60

  access_logs {
    bucket  = var.log_bucket
    prefix  = "alb-logs/${var.project}-${var.environment}"
    enabled = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Create HTTP listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Create HTTPS listener
resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0
  
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Create main target group
resource "aws_lb_target_group" "main" {
  name     = "${var.project}-${var.environment}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-tg"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Create Network Load Balancer (if enabled)
resource "aws_lb" "nlb" {
  count = var.create_nlb ? 1 : 0
  
  name               = "${var.project}-${var.environment}-nlb"
  internal           = var.internal_nlb
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = var.log_bucket
    prefix  = "nlb-logs/${var.project}-${var.environment}"
    enabled = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-nlb"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# NLB listener
resource "aws_lb_listener" "nlb" {
  count = var.create_nlb ? 1 : 0
  
  load_balancer_arn = aws_lb.nlb[0].arn
  port              = var.nlb_port
  protocol          = var.nlb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb[0].arn
  }
}

# NLB target group
resource "aws_lb_target_group" "nlb" {
  count = var.create_nlb ? 1 : 0
  
  name     = "${var.project}-${var.environment}-nlb-tg"
  port     = var.nlb_target_port
  protocol = var.nlb_protocol
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = var.nlb_health_check_path
    port                = var.nlb_health_check_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }

  tags = {
    Name        = "${var.project}-${var.environment}-nlb-tg"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# ALB CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.project}-${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "This alarm monitors ALB 5XX error count"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions

  dimensions = {
    LoadBalancer = aws_lb.alb.arn_suffix
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
