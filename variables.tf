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

variable "enable_ipv6" {
  description = "Specifies whether to enable IPv6"
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
  description = "Public subnets config"
  type        = any
  default     = []
}

variable "public_route_table_ids" {
  description = "Public route table ids"
  type        = list(any)
  default     = []
}

variable "private_subnets" {
  description = "Private subnets config"
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
  type        = list(any)
  validation {
    condition     = alltrue([for rule in var.nacl_ingress : length(lookup(rule, "cidr_blocks", [])) > 0])
    error_message = "You must have to declare at least one CIDR block in nacl_ingress."
  }
}

variable "nacl_egress" {
  description = "Network ACLs for outbound traffic in Subnets"
  type        = list(any)
  validation {
    condition     = alltrue([for rule in var.nacl_egress : length(lookup(rule, "cidr_blocks", [])) > 0])
    error_message = "You must have to declare at least one CIDR block in nacl_egress."
  }
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