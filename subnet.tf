########################
#  subnet/subnet.tf  #
########################

#------------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------------
locals {
  public_subnets = flatten([
    for subnet in var.public_subnets : [
      for index, cidr_block in subnet.cidr_blocks : {
        cidr_block        = "${subnet.network}.${cidr_block}"
        availability_zone = var.availability_zones[ (index % length(var.availability_zones)) ]
      }
    ]
  ])

  private_subnets = flatten([
    for subnet in var.private_subnets : [
      for index, cidr_block in subnet.cidr_blocks : {
        cidr_block        = "${subnet.network}.${cidr_block}"
        availability_zone = var.availability_zones[ (index % length(var.availability_zones)) ]
      }
    ]
  ])

  nacl_ingress = flatten([
    for idx, rule in var.nacl_ingress : [
      for index in range(length(rule.cidr_blocks)) : {
        from_port   = try(lookup(rule, "from_port"), lookup(rule, "port"))
        to_port     = try(lookup(rule, "to_port"), lookup(rule, "port"))
        rule_action = lookup(rule, "rule_action", "allow")
        protocol    = lookup(rule, "protocol", "-1")
        cidr_block  = tolist(rule.cidr_blocks)[index]
        rule_number = ((idx + 2) * 100) + index
        egress      = false
      }
    ]
  ])

  nacl_egress = flatten([
    for idx, rule in var.nacl_egress : [
      for index in range(length(rule.cidr_blocks)) : {
        from_port   = try(lookup(rule, "from_port"), lookup(rule, "port"))
        to_port     = try(lookup(rule, "to_port"), lookup(rule, "port"))
        rule_action = lookup(rule, "rule_action", "allow")
        protocol    = lookup(rule, "protocol", "-1")
        cidr_block  = tolist(rule.cidr_blocks)[index]
        rule_number = ((idx + 2) * 100) + index
        egress      = true
      }
    ]
  ])

  public_subnet_ids                 = [for subnet in aws_subnet.public_subnet : subnet.id]
  public_subnet_availability_zones  = [for subnet in aws_subnet.public_subnet : subnet.availability_zone]
  public_subnet_cidr_blocks         = [for subnet in aws_subnet.public_subnet : subnet.cidr_block]
  private_subnet_ids                = [for subnet in aws_subnet.private_subnet : subnet.id]
  private_subnet_availability_zones = [for subnet in aws_subnet.private_subnet : subnet.availability_zone]
  private_subnet_cidr_blocks        = [for subnet in aws_subnet.private_subnet : subnet.cidr_block]
}

#------------------------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet" {
  for_each                = { for subnet in local.public_subnets : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
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
  count          = length(keys(aws_subnet.public_subnet))
  subnet_id      = element([for subnet in aws_subnet.public_subnet : subnet.id], count.index)
  route_table_id = element(var.public_route_table_ids, count.index)
}

#------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet" {
  for_each                = { for subnet in local.private_subnets : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
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
  count          = length(keys(aws_subnet.private_subnet))
  subnet_id      = element([for subnet in aws_subnet.private_subnet : subnet.id], count.index)
  route_table_id = element(var.private_route_table_ids, count.index)
}

## Network ACL
resource "aws_network_acl" "nacl" {
  count  = var.create_acl ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

## Network ACL association
resource "aws_network_acl_association" "nacl_association" {
  for_each       = var.create_acl ? { for subnet in aws_subnet.private_subnet : "${subnet.availability_zone}-${subnet.cidr_block}" => subnet } : {}
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.nacl[0].id
}

## Network ACL rule for inbound traffic
resource "aws_network_acl_rule" "ingress_nacl_rule" {
  for_each       = var.create_acl ? { for index, rule in local.nacl_ingress : "${var.name}-${rule.rule_number}-${rule.egress}" => rule } : {}
  network_acl_id = aws_network_acl.nacl[0].id
  rule_number    = lookup(each.value, "rule_number")
  egress         = lookup(each.value, "egress")
  protocol       = lookup(each.value, "protocol")
  rule_action    = lookup(each.value, "rule_action")
  cidr_block     = lookup(each.value, "cidr_block")
  from_port      = lookup(each.value, "from_port")
  to_port        = lookup(each.value, "to_port")
}

## Network ACL rule for outbound traffic
resource "aws_network_acl_rule" "egress_nacl_rule" {
  for_each       = var.create_acl ? { for index, rule in local.nacl_egress : "${var.name}-${rule.rule_number}-${rule.egress}" => rule } : {}
  network_acl_id = aws_network_acl.nacl[0].id
  rule_number    = lookup(each.value, "rule_number")
  egress         = lookup(each.value, "egress")
  protocol       = lookup(each.value, "protocol")
  rule_action    = lookup(each.value, "rule_action")
  cidr_block     = lookup(each.value, "cidr_block")
  from_port      = lookup(each.value, "from_port")
  to_port        = lookup(each.value, "to_port")
}