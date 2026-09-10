##########################
#  subnet/variables.tf  #
##########################

variable "assign_ipv6_address_on_creation" {
  description = "Specifies whether to assign ipv6 address to resources in subnet on creation"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Number of availability zones for subnet deployment"
  type        = list(any)
}

variable "create_acl" {
  description = "Create ACL"
  type        = bool
  default     = false
}

variable "enable_dns64" {
  description = "Specifies whether to enable DNS64"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Specifies whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Specifies whether to respond to DNS queries for instance hostnames with DNS AAAA records"
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = "Public subnets config. IPv6 is mandatory: each entry must set both ipv6_network and ipv6_cidr_blocks alongside network and cidr_blocks"
  type        = any
  default     = []
}

variable "public_route_table_ids" {
  description = "Public route table ids"
  type        = list(any)
  default     = []
}

variable "private_subnets" {
  description = "Private subnets config. IPv6 is optional: omit ipv6_network and ipv6_cidr_blocks on an entry to create that subnet as IPv4-only"
  type        = any
  default     = []
}

variable "private_route_table_ids" {
  description = "Public route table ids"
  type        = list(any)
  default     = []
}

variable "nacl_ingress" {
  description = "Network ACLs for inbound traffic in Subnets"
  type = list(object({
    port             = optional(number)
    from_port        = optional(number)
    to_port          = optional(number)
    protocol         = optional(string, "-1")
    rule_action      = optional(string, "allow")
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "nacl_egress" {
  description = "Network ACLs for outbound traffic in Subnets"
  type = list(object({
    port             = optional(number)
    from_port        = optional(number)
    to_port          = optional(number)
    protocol         = optional(string, "-1")
    rule_action      = optional(string, "allow")
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "Name tag"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}