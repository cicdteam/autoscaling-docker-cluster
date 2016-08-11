resource "aws_eip" "control" {
  instance = "${module.instance.id}"
  vpc      = true
#  lifecycle { create_before_destroy = true }
  provisioner "local-exec" { command = "echo Waiting 10 seconds for EIP to propagate; sleep 10" }
}

resource "aws_route53_record" "control" {
  zone_id = "${var.route53_zone_id}"
  name    = "control"
  type    = "A"
  ttl     = "60"
  records = ["${module.instance.private_ip}"]
  lifecycle { create_before_destroy = true }
}
