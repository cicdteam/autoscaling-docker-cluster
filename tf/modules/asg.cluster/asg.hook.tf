resource "aws_sqs_queue" "cluster" {
  name                       = "${var.name}"
  visibility_timeout_seconds = 5
  max_message_size           = 2048
  message_retention_seconds  = 86400
}

resource "aws_autoscaling_lifecycle_hook" "cluster" {
    name                     = "${var.name}"
    autoscaling_group_name   = "${aws_autoscaling_group.cluster.name}"
    default_result           = "CONTINUE"
    heartbeat_timeout        = 1800 # half hour
    lifecycle_transition     = "autoscaling:EC2_INSTANCE_TERMINATING"
    notification_target_arn  = "${aws_sqs_queue.cluster.arn}"
    role_arn                 = "${aws_iam_role.asg.arn}"
}
