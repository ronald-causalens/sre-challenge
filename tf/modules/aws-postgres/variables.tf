variable "subnet_group_name" {
  type = string
  description = "Name of the subnet group to use with the instance"
}

variable "customer_name" {
  type        = string
  description = "Name of the customer (will be used as a prefix for all instance resources)"
}

variable "admin_username" {
  description = "Database admin username"
}

variable "admin_password" {
  description = "Database admin password"
}

variable "security_group_id" {
  type = string
  description = "The security group id to use with the RDS instance"
}

variable "machine_type" {
  type        = string
  default     = "db.m6g.xlarge"
  description = "Type of machine to use for VM instances"
}

variable "min_storage" {
  type = number
  default = 5
  description = "The minimum storage space to allocate"
}