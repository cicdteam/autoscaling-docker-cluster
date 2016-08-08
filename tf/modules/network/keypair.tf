#
# A default key pair is used to control login access to EC2 instances.
#
resource "aws_key_pair" "default" {
  key_name   = "${var.name}-key"
  public_key = "${file("${var.public_key_path}")}"
  lifecycle { create_before_destroy = true }
}
output "key_name" {value = "${aws_key_pair.default.key_name}"}
