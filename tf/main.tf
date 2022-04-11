terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "3.57.0"
      }
      ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "ansiblevault" {
  vault_path  = "../../vault_password.txt"
  root_folder = "./"
}

data "ansiblevault_path" "db_user" {
  path = "./secrets.yml.encrypted"
  key  = "db_master_user"
}

data "ansiblevault_path" "db_pass" {
  path = "./secrets.yml.encrypted"
  key  = "db_master_pass"
}

locals {
  customer_name = "xxxxx"
  location = "eu-west-2"
  public_key    = file("xxxxx.pem.pub")
}

module "network" {
    source = "modules/aws-network"
    customer_name = local.customer_name
    region = local.location
}

 module "web" {
    source = "modules/aws-instance"
    role = "web"
    machine_type = "t3a.xlarge"
    disk_size = 512
    public_key = local.public_key
    vpc_id = module.network.vpc.id
    security_group_id = module.network.security_group.id
    subnet_id = module.network.subnet.id
    customer_name = local.customer_name
    associate_public_ip_address = true
 }

 module "db" {
   source = "modules/aws-postgres"
   subnet_group_name = module.network.db_subnet_group.name
   customer_name = local.customer_name
   admin_username = data.ansiblevault_path.db_user.value
   admin_password = data.ansiblevault_path.db_pass.value
   security_group_id = module.network.security_group.id
   machine_type = "db.m6g.large"
   min_storage = 20
 }