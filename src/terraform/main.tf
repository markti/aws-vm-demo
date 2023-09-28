resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8)
}

output "public_subnets" {
  value = local.public_subnets
}

resource "aws_subnet" "frontend" {

  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = local.public_subnets[count.index]
}

data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.frontend_image_name]
  }
}

resource "aws_network_interface" "frontend" {
  count     = length(local.public_subnets)
  subnet_id = aws_subnet.frontend[count.index].id
}

resource "aws_instance" "frontend" {
  count = length(local.public_subnets)

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type

  network_interface {
    network_interface_id = aws_network_interface.frontend[count.index].id
    device_index         = 0
  }

}
resource "aws_lb" "frontend" {
  name                       = "${var.application_name}-${var.environment_name}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.frontend.*.id
  enable_deletion_protection = false # You can set this to true if you want to enable deletion protection
  security_groups            = [aws_security_group.frontend_lb.id]
}

resource "aws_security_group" "frontend_lb" {
  name        = "${var.application_name}-${var.environment_name}-frontend-lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.frontend_lb.id
}
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.frontend_lb.id
}

resource "aws_lb_target_group" "frontend_http" {
  name                = "${var.application_name}-${var.environment_name}-frontend"
  port                = 80
  protocol            = "HTTP"
  vpc_id              = aws_vpc.main.id
  path                = "/health" # The path to the health check endpoint
  interval            = 30        # Check the health every 30 seconds
  timeout             = 5         # Allow up to 5 seconds for a response
  healthy_threshold   = 2         # Require 2 consecutive successful checks
  unhealthy_threshold = 2         # Mark unhealthy after 2 consecutive failures
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
