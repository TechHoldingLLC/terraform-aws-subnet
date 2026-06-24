# Subnet
Below is an examples of calling this module.

> **IPv6 is mandatory.** Every entry in `public_subnets` and `private_subnets` must include `ipv6_network` and `ipv6_cidr_blocks` alongside the IPv4 `network` and `cidr_blocks`. The parent VPC must have an IPv6 CIDR assigned (`assign_generated_ipv6_cidr_block = true`).

## Create a Subnet
```
module "subnet" {
  source             = "./subnet"
  name               = "my-project-subnet"
  vpc_id             = "vpc-x1y2z3"
}
```

## Create private subnet with default nacl rule
```
module "private_subnet" {
  source                  = "./subnet"
  name                    = "my-project-private-subnet"
  vpc_id                  = module.vpc.id
  availability_zones      = module.vpc.availability_zones
  private_route_table_ids = module.vpc.private_route_table_ids
  private_subnets = [          # do not forget to update these values according to the need
    {
      network = "10.0"
      cidr_blocks = [
        "106.0/24",
        "107.0/24"
      ]
      ipv6_network = substr(module.vpc.ipv6_cidr_block, 0, 17)
      ipv6_cidr_blocks = [
        "60::/64",
        "61::/64"
      ]
    }
  ]
}
```

## Create a Private Subnet with custom name, vpc_id, availability_zones, private_route_table_ids, private_subnets values and nacl rules
Note: Before creating this module, You need to create a VPC.  

```
module "private_subnet" {
  source             = "./subnet"
  name               = "my-project-private-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones
  create_acl         = true

  # Private subnets
  private_route_table_ids = module.vpc.private_route_table_ids
  private_subnets = [          # do not forget to update these values according to the need
    {
      network = "10.0"
      cidr_blocks = [
        "106.0/24",
        "107.0/24"
      ]
      ipv6_network = substr(module.vpc.ipv6_cidr_block, 0, 17)
      ipv6_cidr_blocks = [
        "60::/64",
        "61::/64"
      ]
    }
  ]

  # NACL rules accept IPv4 (`cidr_blocks`) and/or IPv6 (`ipv6_cidr_blocks`) per rule.
  # At least one of the two is required. You can mix patterns across rules:
  #   - both:   matches IPv4 and IPv6 traffic (one AWS NACL rule per CIDR is created)
  #   - v4 only: omit `ipv6_cidr_blocks`
  #   - v6 only: omit `cidr_blocks`
  nacl_ingress = [
    {
      # Rule with BOTH IPv4 and IPv6 — allow inbound HTTPS from these CIDRs
      port             = 443
      protocol         = "tcp"
      rule_action      = "allow"
      cidr_blocks      = ["1.1.1.1/32", "2.2.2.1/32"]
      ipv6_cidr_blocks = ["2001:db8::/32"]
    },
    {
      # Rule with IPv4 ONLY — allow SSH from a specific office IP
      port        = 22
      protocol    = "tcp"
      rule_action = "allow"
      cidr_blocks = ["203.0.113.5/32"]
    },
    {
      # Rule with IPv6 ONLY — allow inbound HTTP from any IPv6 source
      port             = 80
      protocol         = "tcp"
      rule_action      = "allow"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  nacl_egress = [
    {
      # Allow all outbound IPv4 and IPv6
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      rule_action      = "allow"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  providers = {
    aws = aws
  }
}
```


## Create a Public Subnet with custom name, vpc_id, availability_zones, private_route_table_ids, private_subnets values
```
module "public_subnet" {
  source             = "../terraform-subnet"
  name               = "my-project-public-subnet"
  vpc_id             = module.vpc.id
  availability_zones = module.vpc.availability_zones

  # Public subnets
  public_route_table_ids = module.vpc.public_route_table_ids
  public_subnets = [
    {
      network = "10.0"       # do not forget to update these values according to the need
      cidr_blocks = [
        "0.0/24",
        "1.0/24"
      ]
      ipv6_network = substr(module.vpc.ipv6_cidr_block, 0, 17)
      ipv6_cidr_blocks = [
        "00::/64",
        "01::/64"
      ]
    }
  ]

  providers = {
    aws = aws
  }

}
```

## Create a Public/Private Subnet with optional IPv6 toggles enabled
```
module "subnet" {
  source                  = "../terraform-aws-subnet"
  name                    = "subnet-name"
  vpc_id                  = module.vpc.id
  availability_zones      = module.vpc.availability_zones
  public_route_table_ids  = module.vpc.public_route_table_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  assign_ipv6_address_on_creation                = true ## Set true to auto-assign an IPv6 address to ENIs created in the subnet
  enable_dns64                                   = true ## Set true to enable DNS64 (typically used with IPv6-only subnets)
  enable_resource_name_dns_a_record_on_launch    = true ## Set true so resource-based hostnames return an A record (IPv4)
  enable_resource_name_dns_aaaa_record_on_launch = true ## Set true so resource-based hostnames return an AAAA record (IPv6)

  public_subnets = [
    {
      network = "10.0"
      cidr_blocks = [
        "11.0/24"
      ]
      ipv6_network = substr(module.vpc.ipv6_cidr_block, 0, 17)
      ipv6_cidr_blocks = [
        "81::/64"
      ]
    }
  ]

  private_subnets = [
    {
      network = "10.0"
      cidr_blocks = [
        "121.0/24"
      ]
      ipv6_network = substr(module.vpc.ipv6_cidr_block, 0, 17)
      ipv6_cidr_blocks = [
        "91::/64"
      ]
    }
  ]
}

```