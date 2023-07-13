
data "aws_ami" "latest_amazon_linux" {
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

data "aws_availability_zones" "available" {}

resource "aws_launch_template" "web" {
  name                   = "WebServer-Highly-Available-LT-${var.env}"
  image_id               = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  user_data              = filebase64("./user_data.sh")
  tags = {
    Name = "${var.env}-ec2"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "WebServer-Highly-Available-ASG-Ver-${aws_launch_template.web.latest_version}"
  min_size            = var.count_ec2_instance
  max_size            = var.count_ec2_instance
  min_elb_capacity    = var.count_ec2_instance
  health_check_type   = "ELB"
  vpc_zone_identifier = toset(var.subnets)
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG-v${aws_launch_template.web.latest_version} - ${var.env}"
      TAGKEY = "TAGVALUE"
    }
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

#-------------------------------------------------------------------------------
resource "aws_lb" "web" {
  name               = "HighlyAvailable-ALB-${var.env}"
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  # security_groups    = [aws_security_group.web.id]
  # subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  subnets = toset(var.subnets)
}

resource "aws_lb_target_group" "web" {
  name                 = "HighlyAvailable-TG-${var.env}"
  vpc_id               = var.vpc_id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10 # seconds
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
