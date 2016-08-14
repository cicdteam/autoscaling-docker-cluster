# $ host cloud.docker.com
# cloud.docker.com is an alias for elb-default.us-east-1.aws.dckr.io.
# elb-default.us-east-1.aws.dckr.io is an alias for us-east-1-elbdefau-1nlhaqqbnj2z8-140214243.us-east-1.elb.amazonaws.com.
# us-east-1-elbdefau-1nlhaqqbnj2z8-140214243.us-east-1.elb.amazonaws.com has address 52.72.199.43
# us-east-1-elbdefau-1nlhaqqbnj2z8-140214243.us-east-1.elb.amazonaws.com has address 54.165.204.109
# us-east-1-elbdefau-1nlhaqqbnj2z8-140214243.us-east-1.elb.amazonaws.com has address 54.86.192.155
#
# $ host ws.cloud.docker.com
# ws.cloud.docker.com is an alias for tutum-live-prod.dc.tutum.co.
# tutum-live-prod.dc.tutum.co has address 50.16.168.75
# tutum-live-prod.dc.tutum.co has address 52.202.215.230


resource "aws_route" "dc_api_1" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "52.72.199.43/32"
  gateway_id             = "${aws_internet_gateway.public.id}"
  depends_on             = ["aws_route_table.private"]
}
resource "aws_route" "dc_api_2" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "54.165.204.109/32"
  gateway_id             = "${aws_internet_gateway.public.id}"
  depends_on             = ["aws_route_table.private"]
}
resource "aws_route" "dc_api_3" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "54.86.192.155/32"
  gateway_id             = "${aws_internet_gateway.public.id}"
  depends_on             = ["aws_route_table.private"]
}
resource "aws_route" "dc_wsapi_1" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "50.16.168.75/32"
  gateway_id             = "${aws_internet_gateway.public.id}"
  depends_on             = ["aws_route_table.private"]
}
resource "aws_route" "dc_wsapi_2" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "52.202.215.230/32"
  gateway_id             = "${aws_internet_gateway.public.id}"
  depends_on             = ["aws_route_table.private"]
}
