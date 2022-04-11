resource "aws_vpc" "vpc" {
  tags = {
    Name = "${var.customer_name}-vpc"
  }
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "172.16.20.0/24"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "subnet3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "172.16.30.0/24"
  availability_zone = "${var.region}c"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.customer_name}-db-group"
  subnet_ids = [ aws_subnet.subnet.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id ]
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.customer_name}-gateway"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "${var.customer_name}-igw-route-table"
  }
}

resource "aws_route_table_association" "rta_subnet" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_security_group" "sg" {
  name = "${var.customer_name}-security-group"
  vpc_id = aws_vpc.vpc.id
  ingress = [
      {
          description = "Allow https"
          from_port = 443
          to_port = 443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = null
          prefix_list_ids = null
          security_groups = null
          self = null
      },
      {
          description = "Allow http"
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = null
          prefix_list_ids = null
          security_groups = null
          self = null
      },
      {
          description = "Allow ssh"
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["${var.vpn_cidr}"]
          ipv6_cidr_blocks = null
          prefix_list_ids = null
          security_groups = null
          self = null
      },
      {
          description = "Allow internal"
          from_port = 1000
          to_port = 65535
          protocol = "tcp"
          cidr_blocks = ["172.16.0.0/16"]
          ipv6_cidr_blocks = null
          prefix_list_ids = null
          security_groups = null
          self = null
      }
  ]
}

output "vpc" {
  value = aws_vpc.vpc
}

output "security_group" {
  value = aws_security_group.sg
}

output "subnet" {
  value = aws_subnet.subnet
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group
}