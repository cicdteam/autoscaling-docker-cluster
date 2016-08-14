data "template_file" "nodeinit" {
  template   = "${file("${path.module}/templates/node.init.tmpl")}"
  vars {
    hostname         = "node"
    domain           = "${var.domain_name}"
    route53_zone_id  = "${var.route53_zone_id}"
    region           = "${var.region}"
    queue            = "${var.name}"
    hookname         = "${var.name}"
    asgname          = "${var.name}"
    control_ip       = "${var.control_ip}"
    cluster          = "${var.name}"
    docker_user      = "${var.docker_user}"
    docker_pass      = "${var.docker_pass}"
    route_table      = "${var.route_table}"
    internet_gateway = "${var.internet_gateway}"
  }
}

module "cluster" {
  source             = "../asg.cluster"
  region             = "${var.region}"
  name               = "${var.name}"
  key_name           = "${var.key_name}"
  cluster_min        = "${var.cluster_min}"
  cluster_max        = "${var.cluster_max}"
  instance_type      = "${var.cluster_instance}"
  subnet_ids         = "${var.subnet_ids}"
  availability_zones = "${var.availability_zones}"
  security_group_ids = "${aws_security_group.cluster.id}"
  user_data          = "${data.template_file.nodeinit.rendered}"
  route53_zone_id    = "${var.route53_zone_id}"
}
