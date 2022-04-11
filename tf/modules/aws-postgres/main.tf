resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "aws_db_instance" "db" {
  allocated_storage = var.min_storage
  max_allocated_storage = 100

  engine = "postgres"
  engine_version = 13
  port = 5432

  instance_class = var.machine_type

  storage_encrypted = true

  name = "${var.customer_name}db${random_id.db_name_suffix.hex}"
  identifier = "${var.customer_name}-db-${random_id.db_name_suffix.hex}"
  username = var.admin_username
  password = var.admin_password

  backup_retention_period = 7
  
  db_subnet_group_name = var.subnet_group_name

  tags = {
    Name = "${var.customer_name}-db"
  }
  vpc_security_group_ids = [ "${var.security_group_id}" ]
  final_snapshot_identifier = "${var.customer_name}-db-final-snapshot"
}