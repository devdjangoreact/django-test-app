#-------------------------------------------------------------------------------
resource "aws_lb" "web" {
  name               = "HighlyAvailable-ALB-${var.env}"
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  # security_groups    = [aws_security_group.web.id]
  # subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  subnets = toset(var.public_subnets)
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
