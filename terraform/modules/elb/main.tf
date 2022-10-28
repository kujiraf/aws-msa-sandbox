resource "aws_lb" "this" {
  for_each = { for g in var.ha_groups : g.name => g }

  load_barancer_type = var.lb_type
  name               = each.value.name
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = [for subnet in var.subnets : subnet.id]
  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_listener" "forward_listener" {
  for_each = { for l in var.listners : l.port => l }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}
