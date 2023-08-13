resource "aws_subnet" "subnets" {
  for_each          = { for s in var.subnets : s.name => s }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = merge(var.tags, { Name = each.value.name })
}

resource "aws_route_table" "route_table" {
  tags = {
    Name = var.route_table_name
  }
  vpc_id = var.vpc_id

  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "aws_route" "default_gw_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  # for public route
  gateway_id = var.igw_id
  # for private route
  nat_gateway_id = var.nat_gw_id

  depends_on = [aws_route_table.route_table]
}

resource "aws_route_table_association" "route_table_association" {
  for_each       = { for s in var.subnets : s.name => s }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.route_table.id
}
