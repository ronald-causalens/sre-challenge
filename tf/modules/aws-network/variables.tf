variable "customer_name" {
  type        = string
  description = "Name of the customer (will be used as a prefix for all instance resources)"
}

variable "region" {
  type        = string
  description = "The region for the subnet"
}

variable "vpn_cidr" {
  type        = string
  description = "The CIDR for secure VPN connections"
}