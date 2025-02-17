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