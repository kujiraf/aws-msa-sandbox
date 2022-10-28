resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  name        = var.name
  description = var.description
  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "this" {
  security_group_id        = aws_security_group.this.id
  for_each                 = var.rules
  type                     = each.value[0]
  protocol                 = each.value[1]
  from_port                = each.value[2]
  to_port                  = each.value[3]
  source_security_group_id = each.value[4]
  cidr_blocks              = each.value[5]
  description              = each.value[6]
}
