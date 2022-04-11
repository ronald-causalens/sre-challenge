variable "role" {
  type = string
  description = "What this instance will be used for (e.g. web or worker)"
}

variable "machine_type" {
  type        = string
  default     = "t3a.xlarge"
  description = "Type of machine to use for VM instances"
}

variable "ami" {
  type = string
  default = "ami-09a56048b08f94cdf"
  description = "The AMI id to image the machine with"
}

variable "disk_size" {
  type        = number
  default     = 120
  description = "Type size of the disk, defaults to 120GB"
}

variable "public_key" {
  type        = string
  description = "Public Key to use for the instance"
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC to use with the instance"
}

variable "security_group_id" {
  type = string
  description = "ID of the SG to use with the instance"
}

variable "subnet_id" {
  type = string
  description = "ID of the subnet to use with the instance"
}

variable "customer_name" {
  type        = string
  description = "Name of the customer (will be used as a prefix for all instance resources)"
}

variable "associate_public_ip_address" {
  type = bool
  description = "Whether or not to associate a public ip address with this instance"
}