data "template_file" "init" {
  template = "${file("${path.module}/templates/user_data.tpl.yml")}"
  vars {
    hostname = "bastion"
    domain   = "${var.domain_name}"
  }
}

module "instance" {
  source             = "../ec2"
  region             = "${var.region}"
  instance_name      = "${var.name}"
  instance_type      = "t2.nano"
  key_name           = "${var.key_name}"
  subnet_id          = "${var.subnet_id}"
  availability_zone  = "${var.availability_zone}"
  security_group_ids = "${aws_security_group.bastion.id}"
  user_data          = "${data.template_file.init.rendered}"
}

output "public_ip" {value = "${aws_eip.bastion.public_ip}"}
