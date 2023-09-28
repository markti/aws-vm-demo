/*
resource "aws_lb" "frontend" {
  name                       = "${var.application_name}-${var.environment_name}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.frontend.*.id
  enable_deletion_protection = false # You can set this to true if you want to enable deletion protection
  security_groups            = [aws_security_group.frontend_lb.id]
}

resource "aws_lb_target_group" "frontend_http" {
  name     = "${var.application_name}-${var.environment_name}-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_http.arn
  }
}
resource "aws_lb_target_group_attachment" "frontend_http" {
  count            = length(local.public_subnets)
  target_group_arn = aws_lb_target_group.frontend_http.arn
  target_id        = aws_instance.frontend[count.index].id
}
*/