#
# EC2 instance related IAM stuff
#
resource "aws_iam_instance_profile" "cluster" {
    name = "${var.name}-ec2profile"
    roles = ["${aws_iam_role.cluster.name}"]
}
resource "aws_iam_role" "cluster" {
    name = "${var.name}-ec2role"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy" "cluster" {
    name = "${var.name}-ec2policy"
    role = "${aws_iam_role.cluster.id}"
    policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "route53:ChangeResourceRecordSets",
            "route53:GetHostedZone",
            "route53:ListResourceRecordSets"
         ],
         "Resource":"arn:aws:route53:::hostedzone/${var.route53_zone_id}"
      },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ListQueues",
                "sqs:GetQueueUrl"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage"
            ],
            "Resource": "${aws_sqs_queue.cluster.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "ec2:CreateTags",
            "Resource": "*"
        }
   ]
}
EOF
}

#
# Autoscaling Group IAM related stuff
#
resource "aws_iam_role" "asg" {
    name = "${var.name}-asgrole"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy" "asg" {
    name = "${var.name}-asgpolicy"
    role = "${aws_iam_role.asg.id}"
    policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "sqs:SendMessage",
            "sqs:GetQueueUrl",
            "sns:Publish"
         ],
         "Resource":"${aws_sqs_queue.cluster.arn}"
      }
   ]
}
EOF
}
