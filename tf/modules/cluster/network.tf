resource "aws_security_group" "cluster" {
  name        = "${var.name}-sg"
  vpc_id      = "${var.vpc_id}"
  description = "${var.name} security group"
  tags { Name = "${var.name}" }
  lifecycle { create_before_destroy = true }

#  ingress {
#    protocol    = -1
#    from_port   = 0
#    to_port     = 0
#    cidr_blocks = ["${var.vpc_cidr}"]
#  }
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
