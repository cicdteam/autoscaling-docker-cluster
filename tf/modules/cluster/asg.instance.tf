module "ubuntu" {
  source = "../ubuntu.images"
  region = "${var.region}"
}

resource "aws_launch_configuration" "cluster" {
  name_prefix          = "${var.name}-"
  image_id             = "${module.ubuntu.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${split(",", var.security_group_ids)}"]
  user_data            = "${var.user_data}"
  enable_monitoring    = true
  iam_instance_profile = "${aws_iam_instance_profile.cluster.name}"
  associate_public_ip_address = false
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "cluster" {
    depends_on = ["aws_launch_configuration.cluster"]
    name = "${var.name}"
    launch_configuration = "${aws_launch_configuration.cluster.name}"
    min_size = "${var.cluster_min}"
    max_size = "${var.cluster_max}"
    desired_capacity = "${var.cluster_min}"
    vpc_zone_identifier = ["${split(",", var.subnet_ids)}"]
    termination_policies = ["OldestInstance"]
    tag {
      key = "Name"
      value = "${var.name}"
      propagate_at_launch = true
    }
    lifecycle { create_before_destroy = true }
}
