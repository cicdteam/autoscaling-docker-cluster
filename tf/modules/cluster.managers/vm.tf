data "template_file" "nodeinit" {
  template   = "${file("${path.module}/templates/node.init.tmpl")}"
  vars {
    hostname        = "manager"
    domain          = "${var.domain_name}"
    route53_zone_id = "${var.route53_zone_id}"
    region          = "${var.region}"
    queue           = "${var.name}"
    hookname        = "${var.name}"
    asgname         = "${var.name}"
  }
}

module "cluster" {
  source             = "../cluster"
  region             = "${var.region}"
  name               = "${var.name}"
  instance_type      = "t2.micro"
  key_name           = "${var.key_name}"
  cluster_min        = "0"
  cluster_max        = "5"
  subnet_ids         = "${var.subnet_ids}"
  availability_zones = "${var.availability_zones}"
  security_group_ids = "${aws_security_group.managers.id}"
  user_data          = "${data.template_file.nodeinit.rendered}"
  route53_zone_id    = "${var.route53_zone_id}"
}
