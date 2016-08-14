#
# Define AWS Virtual Private Cloud
#
resource "aws_vpc" "default" {
  depends_on           = ["aws_vpc_dhcp_options.local"]
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags { Name          = "${var.name}-vpc" }
  lifecycle { create_before_destroy = true }
}
output "vpc_id"            {value = "${aws_vpc.default.id}"}
output "vpc_cidr"          {value = "${var.vpc_cidr}"}
output "availibilty_zones" {value = "${lookup(var.availibilty_zones, var.region)}"}
output "domain_name"       {value = "${var.domain_name}"}

#
# Define AWS Private Subnets. Each zone has its own subnet
#
resource "aws_subnet" "private" {
  depends_on        = ["aws_vpc.default"]
  count             = "${length(split(",", lookup(var.availibilty_zones, var.region)))}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${lookup(var.private_subnet_cidr, element(split(",", lookup(var.availibilty_zones, var.region)), count.index))}"
  availability_zone = "${element(split(",", lookup(var.availibilty_zones, var.region)), count.index)}"
  tags { Name       = "${var.name}-${element(split(",", lookup(var.availibilty_zones, var.region)), count.index)}-private" }
  lifecycle { create_before_destroy = true }
  map_public_ip_on_launch = true
}
output "private_subnet_ids" {value = "${join(",", aws_subnet.private.*.id)}"}

#
# Define AWS Public Subneta. Each zone has its own subnet
#
resource "aws_subnet" "public" {
  count             = "${length(split(",", lookup(var.availibilty_zones, var.region)))}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${lookup(var.public_subnet_cidr, element(split(",", lookup(var.availibilty_zones, var.region)), count.index))}"
  availability_zone = "${element(split(",", lookup(var.availibilty_zones, var.region)), count.index)}"
  tags { Name       = "${var.name}-${element(split(",", lookup(var.availibilty_zones, var.region)), count.index)}-public" }
  lifecycle { create_before_destroy = true }
  map_public_ip_on_launch = true
}
output "public_subnet_ids" {value = "${join(",", aws_subnet.public.*.id)}"}

#
# Define an EIP for the NAT Gateway
#
resource "aws_eip" "nat" {
  depends_on = ["aws_subnet.private"]
  vpc        = true
  provisioner "local-exec" { command  = "echo Waiting 10 seconds for EIP to propagate; sleep 10" }
  lifecycle { create_before_destroy = true }
}
output "nat_ip" {value = "${aws_eip.nat.public_ip}"}

#
# Define Internet Gateway
#
resource "aws_internet_gateway" "public" {
  vpc_id      = "${aws_vpc.default.id}"
  tags { Name = "${var.name}-gw-public" }
  lifecycle { create_before_destroy = true }
}
output "internet_gw_id" {value = "${aws_internet_gateway.public.id}"}

#
# Define a NAT Gateway to route all outbound traffic
#
resource "aws_nat_gateway" "nat" {
  depends_on    = ["aws_internet_gateway.public", "aws_subnet.private"]
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}" # NAT in first public subnet
  lifecycle { create_before_destroy = true }
}
resource "aws_route_table" "public" {
  vpc_id       = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }
  tags { Name  = "${var.name}-table-public" }
  lifecycle { create_before_destroy = true }
}
output "public_rtb_id" {value = "${aws_route_table.public.id}"}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", lookup(var.availibilty_zones, var.region)))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  lifecycle { create_before_destroy = true }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }
  tags { Name = "${var.name}-table-private" }
  lifecycle { create_before_destroy = true }
}
output "private_rtb_id" {value = "${aws_route_table.private.id}"}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", lookup(var.availibilty_zones, var.region)))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
  lifecycle { create_before_destroy = true }
}

resource "aws_route53_zone" "local" {
  name          = "${var.domain_name}"
  vpc_id        = "${aws_vpc.default.id}"
  lifecycle { create_before_destroy = true }
}
output "route53_zone_id" { value = "${aws_route53_zone.local.id}" }

resource "aws_vpc_dhcp_options" "local" {
  domain_name          = "${var.domain_name}"
  domain_name_servers  = ["AmazonProvidedDNS"]
  tags { Name          = "${var.name}"}
  lifecycle { create_before_destroy = true }
  provisioner "local-exec" { command = "echo Waiting 10 seconds for DHCP Options to propagate; sleep 10" }
}

resource "aws_vpc_dhcp_options_association" "local" {
  vpc_id           = "${aws_vpc.default.id}"
  dhcp_options_id  = "${aws_vpc_dhcp_options.local.id}"
  lifecycle { create_before_destroy = true }
}
