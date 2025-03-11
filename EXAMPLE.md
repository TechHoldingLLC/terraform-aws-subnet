# Subnet
Below is an examples of calling this module.

## Create a Public Subnet with default nacl rules
```
module "public_subnet" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-subnet.git?ref=v1.0.0"

  name               = "my-project-public-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  public_subnets = [
    {
      "cidr_block" = "10.0.0.0/24"
    },
    {
      "cidr_block" = "10.0.1.0/24"
    }
  ]

  public_route_table_ids = [aws_route_table.public_route_table.id] # Required if passed value for public_subnets
}
```

## Create private subnet with default nacl rules
```
module "private_subnet" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-subnet.git?ref=v1.0.0"

  name               = "my-project-private-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  private_subnets = [
    {
      "cidr_block" = "10.0.0.0/24"
    },
    {
      "cidr_block" = "10.0.1.0/24"
    }
  ]

  private_route_table_ids = [aws_route_table.private_route_table.id] # Required if passed value for private_subnets
}
```

## Create a Private Subnet with nacl rules
Note: Before creating this module, You need to create a VPC.  

```
module "private_subnet" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-subnet.git?ref=v1.0.0"

  name               = "my-project-private-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  create_acl = true

  # Private subnets
  private_route_table_ids = module.vpc.private_route_table_ids

  private_subnets = [
    {
      "cidr_block" = "10.0.0.0/24"
    },
    {
      "cidr_block" = "10.0.1.0/24"
    }
  ]

  nacl_ingress = [        # do not forget to update port, protocol, rule_actions, cidr_blocks values in ingress and egress according to the need
    {
      port         = 0
      protocol     = "tcp"
      rule_actions = "allow"
      cidr_blocks  = ["1.1.1.1/32", "2.2.2.1/32"]
    }
  ]

  nacl_egress = [
    {
      port         = 0
      protocol     = "-1"
      rule_actions = "allow"
      cidr_blocks  = ["3.3.3.1/32", "4.4.4.1/32"]
    }
  ]

  providers = {
    aws = aws
  }
}
```

## Create dual stack public and private subnets
```
module "subnet" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-subnet.git?ref=v1.0.0"

  name               = "my-project-private-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  public_route_table_ids  = module.vpc.public_route_table_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true ## Set true to assing IPv6 address to resources on creation
  enable_dns64                                   = true ## Set true to enable DNS64
  enable_resource_name_dns_a_record_on_launch    = true ## Set true to enable response to DNS queries for instance hostnames with DNS A records
  enable_resource_name_dns_aaaa_record_on_launch = true ## Set true to enable response to DNS queries for instance hostnames with DNS AAAA records

  public_subnets = [
    {
      "cidr_block"      = "10.0.0.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab00::/64"
    },
    {
      "cidr_block"      = "10.0.1.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab01::/64"
    }
  ]

  public_subnets = [
    {
      "cidr_block"      = "10.0.100.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab64::/64"
    },
    {
      "cidr_block"      = "10.0.101.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab65::/64"
    }
  ]
}
```

## Create IPv4 and dual stack public and private subnets
```
module "subnet" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-subnet.git?ref=v1.0.0"

  name               = "my-project-private-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  public_route_table_ids  = module.vpc.public_route_table_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true 
  enable_dns64                                   = true 
  enable_resource_name_dns_a_record_on_launch    = true 
  enable_resource_name_dns_aaaa_record_on_launch = true 

  public_subnets = [
    {
      "cidr_block"      = "10.0.0.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab00::/64"
    },
    {
      "cidr_block" = "10.0.1.0/24"
    }
  ]

  public_subnets = [
    {
      "cidr_block"      = "10.0.100.0/24"
      "ipv6_cidr_block" = "2001:db8:1234:ab64::/64"
    },
    {
      "cidr_block" = "10.0.101.0/24"
    }
  ]
}
```