/*
resource "aws_lb" "frontend" {
  name                       = "${var.application_name}-${var.environment_name}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.frontend.*.id
  enable_deletion_protection = false # You can set this to true if you want to enable deletion protection
  security_groups            = [aws_security_group.frontend_lb.id]
}

locals {
  frontend_listeners = {
    "HTTP" = 80
    #"HTTPS" = 443
  }
  frontend_attachments = [for k, v in local.frontend_listeners :
    [for i in aws_instance.frontend : {
      name        = k
      port        = v
      instance_id = i.id
      }
    ]
  ]
}

resource "aws_lb_target_group" "frontend" {
  for_each = local.frontend_listeners

  name     = "${var.application_name}-${var.environment_name}-frontend-${each.key}"
  port     = each.value
  protocol = each.key
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "frontend" {
  for_each = local.frontend_listeners

  load_balancer_arn = aws_lb.frontend.arn
  port              = each.value
  protocol          = each.key

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend[each.key].arn
  }
}
*/

/*
resource "aws_lb_target_group_attachment" "frontend" {
  foreach
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = aws_instance.frontend[count.index].id
}
*/