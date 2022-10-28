resource "aws_network_interface" "this" {
  for_each = { for g in var.ha_groups : g.name => g }

  subnet_id       = each.value.subnet.id
  private_ips     = each.value.private_ips
  security_groups = var.sg_id

  tags = {
    Name = each.value.name
  }

}

resource "aws_instance" "this" {
  for_each = { for g in var.ha_groups : g.name => g }

  ami                  = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_profile

  tags = {
    Name = each.value.name
  }

  network_interface {
    network_interface_id = aws_network_interface.this[each.key].id
    device_index         = 0
  }

  # user_data            = var.user_data
  # lifecycle {
  #   ignore_changes = [user_data]
  # }
}

# resource "aws_ebs_volume" "this" {
#   for_each = { for g in var.ha_groups : g.name => g }

#   availability_zone = each.value.subnet.availability_zone
#   size              = var.size
# }

# resource "aws_volume_attachment" "this" {
#   for_each = { for g in var.ha_groups : g.name => g }

#   device_name = var.device_name
#   volume_id   = aws_ebs_volume.this[each.key].id
#   instance_id = aws_instance.this[each.key].id
# }
