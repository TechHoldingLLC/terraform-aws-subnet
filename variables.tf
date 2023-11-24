##########################
#  subnet/variables.tf  #
##########################

variable "availability_zones" {
  description = "Number of availability zones for subnet deployment"
  type        = list(any)
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
  default     = []
}

variable "nacl_egress" {
  description = "Network ACLs for outbound traffic in Subnets"
  type        = list(any)
  default     = []
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