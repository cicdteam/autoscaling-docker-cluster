module "main" {
  source           = "../../tf"

  region                 = "${var.region}"
  name                   = "${var.name}"
  public_key_path        = "${var.public_key_path}"

  cluster_size_min       = "${var.cluster_size_min}
  cluster_size_max       = "${var.cluster_size_max}
  cluster_instance_type  = "${var.cluster_instance_type}"

  docker_user            = "${var.docker_user}"
  docker_pass            = "${var.docker_pass}"
}
