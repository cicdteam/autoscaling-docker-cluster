data "template_file" "init" {
  template = "${file("${path.module}/templates/host.init.tmpl")}"
  vars {
    hostname = "control"
    domain   = "${var.domain_name}"
    region   = "${var.region}"
  }
}

module "instance" {
  source             = "../ec2"
  region             = "${var.region}"
  instance_name      = "${var.name}"
  instance_type      = "t2.micro"
  key_name           = "${var.key_name}"
  subnet_id          = "${var.subnet_id}"
  availability_zone  = "${var.availability_zone}"
  security_group_ids = "${aws_security_group.control.id}"
  user_data          = "${data.template_file.init.rendered}"
}

output "public_ip"  {value = "${aws_eip.control.public_ip}"}
output "private_ip" {value = "${module.instance.private_ip}"}
