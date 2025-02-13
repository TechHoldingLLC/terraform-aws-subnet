# Subnet
Below is an examples of calling this module.

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
    }
  ]

  nacl_ingress = [        # do not forget to update port, protocol, rule_actions, cidr_blocks values in ingress and egress according to the need
    {
      rule_number = 100
      port         = 0
      protocol     = "tcp"
      rule_actions = "allow"
      cidr_blocks  = ["1.1.1.1/32", "2.2.2.1/32"]
    }
  ]

  nacl_egress = [
    {
      rule_number = 100
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
    }
  ]

  providers = {
    aws = aws
  }

}
```

## Create a Public/Private Subnet with IPv6 configuration
```
module "subnet" {
  source                  = "../terraform-aws-subnet"
  name                    = "subnet-name"
  vpc_id                  = module.vpc.id
  availability_zones      = module.vpc.availability_zones
  public_route_table_ids  = module.vpc.public_route_table_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true ## Set true to assing IPv6 address to resources on creation
  enable_dns64                                   = true ## Set true to enable DNS64
  enable_resource_name_dns_a_record_on_launch    = true ## Set true to enable response to DNS queries for instance hostnames with DNS A records
  enable_resource_name_dns_aaaa_record_on_launch = true ## Set true to enable response to DNS queries for instance hostnames with DNS AAAA records

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