resource "aws_security_group" "frontend" {
  name        = "${var.application_name}-${var.environment_name}-frontend-sg"
  description = "Security group for the frontend EC2 instances"
  vpc_id      = aws_vpc.main.id
}

# Allow traffic from the Frontend ALB into the Frontend EC2 Instances
resource "aws_security_group_rule" "frontend_http" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  source_security_group_id = aws_security_group.frontend_lb.id
}

# Allow SSH Access to Frontend EC2 Instances
resource "aws_security_group_rule" "frontend_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}