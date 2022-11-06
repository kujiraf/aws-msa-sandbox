output "public_subnets" {
  value = module.public_subnets.subnets
}

output "private_subnets" {
  value = module.private_subnets.subnets
}
