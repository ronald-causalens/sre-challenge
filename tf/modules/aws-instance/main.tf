data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.tpl")}"
  vars = {
    public_key = "${var.public_key}"
  }
}

resource "aws_instance" "instance" {
    tags = {
      Name = "${var.customer_name}-${var.role}"
      role = var.role,
      backup-plan = "${var.customer_name}-${var.role}-backup-plan"
    }
    instance_type = var.machine_type
    ami = var.ami
    
    root_block_device {
      volume_size = var.disk_size
      encrypted = true
    }

    user_data = "${data.template_file.user_data.rendered}"
    associate_public_ip_address = var.associate_public_ip_address
    vpc_security_group_ids = [ "${var.security_group_id}" ]
    subnet_id = var.subnet_id
}

output "instance" {
  value = aws_instance.instance
}
