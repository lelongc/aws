variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether to automatically accept shared attachments"
  type        = string
  default     = "disable"
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default route table"
  type        = string
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default route table"
  type        = string
  default     = "enable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether VPN ECMP support is enabled"
  type        = string
  default     = "enable"
}

variable "vpc_attachments" {
  description = "List of VPC attachments"
  type        = list(any)
  default     = []
}

variable "tgw_routes" {
  description = "List of routes for the transit gateway"
  type        = list(any)
  default     = []
}
