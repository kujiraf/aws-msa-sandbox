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
  description              = each.value[4]
  cidr_blocks              = lookup(each.value[5], "cidr_blocks", null)
  source_security_group_id = lookup(each.value[5], "source_sg", null)
  self                     = lookup(each.value[5], "self", null)
}
