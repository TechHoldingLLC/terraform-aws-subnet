locals {
  # public subnets
  public_subnets = [
    for index, subnet in var.public_subnets : {
      cidr_block        = "${subnet.cidr_block}"
      availability_zone = element(var.availability_zones, index)
    } if lookup(subnet, "ipv6_cidr_block", null) == null
  ]

  # public subnets dual stack
  public_subnets_dual_stack = [
    for index, subnet in var.public_subnets : {
      cidr_block        = "${subnet.cidr_block}"
      ipv6_cidr_block   = lookup(subnet, "ipv6_cidr_block", null)
      availability_zone = element(var.availability_zones, index)
    } if lookup(subnet, "ipv6_cidr_block", null) != null
  ]

  # private subnets
  private_subnets = [
    for index, subnet in var.private_subnets : {
      cidr_block        = "${subnet.cidr_block}"
      availability_zone = element(var.availability_zones, index)
    } if lookup(subnet, "ipv6_cidr_block", null) == null
  ]

  # private subnets dual stack
  private_subnets_dual_stack = [
    for index, subnet in var.private_subnets : {
      cidr_block        = "${subnet.cidr_block}"
      ipv6_cidr_block   = lookup(subnet, "ipv6_cidr_block", null)
      availability_zone = element(var.availability_zones, index)
    } if lookup(subnet, "ipv6_cidr_block", null) != null
  ]

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
  public_subnet_dual_stack_ids      = [for subnet in aws_subnet.public_subnet_dual_stack : subnet.id]
  public_subnet_availability_zones  = [for subnet in aws_subnet.public_subnet : subnet.availability_zone]
  public_subnet_cidr_blocks         = [for subnet in var.public_subnets : subnet.cidr_block]
  public_subnet_ipv6_cidr_blocks    = [for subnet in var.public_subnets : subnet.ipv6_cidr_block]
  private_subnet_ids                = [for subnet in aws_subnet.private_subnet : subnet.id]
  private_subnet_dual_stack_ids     = [for subnet in aws_subnet.private_subnet_dual_stack : subnet.id]
  private_subnet_availability_zones = [for subnet in aws_subnet.private_subnet : subnet.availability_zone]
  private_subnet_cidr_blocks        = [for subnet in var.private_subnets : subnet.cidr_block]
  private_subnet_ipv6_cidr_blocks   = [for subnet in var.private_subnets : subnet.ipv6_cidr_block]
}