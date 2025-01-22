########################
#  subnet/subnet.tf  #
########################

#------------------------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet" {
  for_each          = { for subnet in local.public_subnets : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", true)
  tags = merge(
    {
      Name = "${var.name}-public-${each.value.availability_zone}"
    },
    var.tags
  )
}

## Public route table association
resource "aws_route_table_association" "public_subnet" {
  count          = length(keys(aws_subnet.public_subnet)) > 0 ? length(keys(aws_subnet.public_subnet)) : 0
  subnet_id      = element([for subnet in aws_subnet.public_subnet : subnet.id], count.index)
  route_table_id = element(var.public_route_table_ids, count.index)
}

#------------------------------------------------------------------------------------
# Public Subnets Dual stack
#------------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet_dual_stack" {
  for_each          = { for subnet in local.public_subnets_dual_stack : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  ipv6_cidr_block = var.enable_ipv6 && lookup(each.value, "ipv6_cidr_block", null) != null ? each.value.ipv6_cidr_block : null

  enable_dns64                                   = var.enable_ipv6 ? var.enable_dns64 : false
  assign_ipv6_address_on_creation                = var.enable_ipv6 ? var.assign_ipv6_address_on_creation : false
  enable_resource_name_dns_a_record_on_launch    = var.enable_ipv6 ? var.enable_resource_name_dns_a_record_on_launch : false
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 ? var.enable_resource_name_dns_aaaa_record_on_launch : false

  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", true)
  tags = merge(
    {
      Name = "${var.name}-public-${each.value.availability_zone}"
    },
    var.tags
  )
}

## Public route table association
resource "aws_route_table_association" "public_subnet_dual_stack" {
  count          = length(keys(aws_subnet.public_subnet_dual_stack)) > 0 ? length(keys(aws_subnet.public_subnet_dual_stack)) : 0
  subnet_id      = element([for subnet in aws_subnet.public_subnet_dual_stack : subnet.id], count.index)
  route_table_id = element(var.public_route_table_ids, count.index)
}

#------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet" {
  for_each          = { for subnet in local.private_subnets : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", false)
  tags = merge(
    {
      Name = "${var.name}-private-${each.value.availability_zone}"
    },
    var.tags
  )
}

## Private route table association
resource "aws_route_table_association" "private_subnet" {
  count          = length(keys(aws_subnet.private_subnet)) > 0 ? length(keys(aws_subnet.private_subnet)) : 0
  subnet_id      = element([for subnet in aws_subnet.private_subnet : subnet.id], count.index)
  route_table_id = element(var.private_route_table_ids, count.index)
}

#------------------------------------------------------------------------------------
# Private Subnets Dual stack
#------------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet_dual_stack" {
  for_each          = { for subnet in local.private_subnets_dual_stack : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  ipv6_cidr_block = var.enable_ipv6 && lookup(each.value, "ipv6_cidr_block", null) != null ? each.value.ipv6_cidr_block : null

  enable_dns64                                   = var.enable_ipv6 ? var.enable_dns64 : false
  assign_ipv6_address_on_creation                = var.enable_ipv6 ? var.assign_ipv6_address_on_creation : false
  enable_resource_name_dns_a_record_on_launch    = var.enable_ipv6 ? var.enable_resource_name_dns_a_record_on_launch : false
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 ? var.enable_resource_name_dns_aaaa_record_on_launch : false

  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", true)
  tags = merge(
    {
      Name = "${var.name}-private-${each.value.availability_zone}"
    },
    var.tags
  )
}

## Public route table association
resource "aws_route_table_association" "private_subnet_dual_stack" {
  count          = length(keys(aws_subnet.private_subnet_dual_stack)) > 0 ? length(keys(aws_subnet.private_subnet_dual_stack)) : 0
  subnet_id      = element([for subnet in aws_subnet.private_subnet_dual_stack : subnet.id], count.index)
  route_table_id = element(var.private_route_table_ids, count.index)
}