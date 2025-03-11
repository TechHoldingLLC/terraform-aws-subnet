########################
#  subnet/outputs.tf  #
########################

output "public_subnet_ids" {
  value = concat(local.public_subnet_ids, local.public_subnet_dual_stack_ids)
}

output "public_subnet_availability_zones" {
  value = local.public_subnet_availability_zones
}

output "public_subnet_cidr_blocks" {
  value = local.public_subnet_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  value = local.public_subnet_ipv6_cidr_blocks
}

output "private_subnet_ids" {
  value = concat(local.private_subnet_ids, local.private_subnet_dual_stack_ids)
}

output "private_subnet_availability_zones" {
  value = local.private_subnet_availability_zones
}

output "private_subnet_cidr_blocks" {
  value = local.private_subnet_cidr_blocks
}

output "private_subnet_ipv6_cidr_blocks" {
  value = local.private_subnet_ipv6_cidr_blocks
}

output "vpc_id" {
  value = var.vpc_id
}