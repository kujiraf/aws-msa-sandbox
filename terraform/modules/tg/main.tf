resource "aws_lb_target_group" "this" {
  vpc_id = var.vpc_id

  name                               = var.tg_name
  port                               = var.tg_port
  protocol                           = var.protocol
  connection_termination             = false
  lambda_multi_value_headers_enabled = false
  proxy_protocol_v2                  = false
  # tags={
  #   Name=var.name
  # }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for g in var.ha_groups : g.name => g }

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this[each.key].id
}
