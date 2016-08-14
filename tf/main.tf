provider "aws" { region = "${var.region}" }

module "network" {
  source          = "modules/network"
  region          = "${var.region}"
  name            = "${var.name}"
  public_key_path = "${var.public_key_path}"
}

module "control" {
  name               = "${var.name}-control"
  source             = "modules/control"
  region             = "${var.region}"
  domain_name        = "${module.network.domain_name}"
  vpc_id             = "${module.network.vpc_id}"
  vpc_cidr           = "${module.network.vpc_cidr}"
  subnet_id          = "${element(split(",", module.network.public_subnet_ids), 0)}"
  availability_zone  = "${element(split(",", module.network.availibilty_zones), 0)}"
  key_name           = "${module.network.key_name}"
  route53_zone_id    = "${module.network.route53_zone_id}"
}
output "control_public_ip" {value = "${module.control.public_ip}"}

module "cluster" {
  source             = "modules/cluster"
  region             = "${var.region}"
  name               = "${var.name}-node"
  key_name           = "${module.network.key_name}"
  control_ip         = "${module.control.private_ip}"
  cluster_min        = "${var.cluster_size_min}"
  cluster_max        = "${var.cluster_size_max}"
  cluster_instance   = "${var.cluster_instance_type}"
  docker_user        = "${var.docker_user}"
  docker_pass        = "${var.docker_pass}"
  route_table        = "${module.network.private_rtb_id}"
  internet_gateway   = "${module.network.internet_gw_id}"
  domain_name        = "${module.network.domain_name}"
  vpc_id             = "${module.network.vpc_id}"
  vpc_cidr           = "${module.network.vpc_cidr}"
  subnet_ids         = "${module.network.private_subnet_ids}"
  availability_zones = "${module.network.availibilty_zones}"
  route53_zone_id    = "${module.network.route53_zone_id}"
}
