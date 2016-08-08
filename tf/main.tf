provider "aws" { region = "${var.region}" }

module "network" {
  source          = "modules/network"
  region          = "${var.region}"
  name            = "${var.name}"
  public_key_path = "${var.public_key_path}"
}

module "bastion" {
  name = "${var.name}-bastion"
  source = "modules/bastion"
  region = "${var.region}"
  domain_name = "${module.network.domain_name}"
  vpc_id = "${module.network.vpc_id}"
  vpc_cidr = "${module.network.vpc_cidr}"
  subnet_id = "${element(split(",", module.network.public_subnet_ids), 0)}"
  availability_zone = "${element(split(",", module.network.availibilty_zones), 0)}"
  key_name = "${module.network.key_name}"
  route53_zone_id = "${module.network.route53_zone_id}"
}
output "bastion_public_ip" {value = "${module.bastion.public_ip}"}

module "manager" {
  source             = "modules/cluster.managers"
  region             = "${var.region}"
  name               = "${var.name}-managers"
  key_name           = "${module.network.key_name}"
  domain_name        = "${module.network.domain_name}"
  vpc_id             = "${module.network.vpc_id}"
  vpc_cidr           = "${module.network.vpc_cidr}"
  subnet_ids         = "${module.network.private_subnet_ids}"
  availability_zones = "${module.network.availibilty_zones}"
  route53_zone_id    = "${module.network.route53_zone_id}"
}
