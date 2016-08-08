module "ami_trusty" {
  source        = "github.com/terraform-community-modules/tf_aws_ubuntu_ami"
  region        = "${var.region}"
  distribution  = "${var.ami_ubuntu_distribution}"
  architecture  = "${var.ami_ubuntu_architecture}"
  virttype      = "${var.ami_virtualization_type}"
  storagetype   = "${var.ami_storage_type}"
}
output "ami_id" { value = "${module.ami_trusty.ami_id}" }