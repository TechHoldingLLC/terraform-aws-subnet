########################
#  subnet/outputs.tf  #
########################

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

output "public_subnet_availability_zones" {
  value = local.public_subnet_availability_zones
}

output "public_subnet_cidr_blocks" {
  value = local.public_subnet_cidr_blocks
}

output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "private_subnet_availability_zones" {
  value = local.private_subnet_availability_zones
}

output "private_subnet_cidr_blocks" {
  value = local.private_subnet_cidr_blocks
}

output "vpc_id" {
  value = var.vpc_id
}