output "ec2" {
  value = aws_instance.this
}

output "target_group" {
  value = aws_lb_target_group.this
}
