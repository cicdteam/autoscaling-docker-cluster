#
# External vars
#
variable "name" {}
variable "region" {}
variable "public_key_path" {}

#
# Internal vars
#
variable "domain_name" {
  description = "Internal domain name"
  default = "local"
}
variable "availibilty_zones" {
  description = "List of AWS availability zones to use within the AWS region"
  type = "map"
  default = {
    us-east-1 = "us-east-1a,us-east-1c"
    eu-west-1 = "eu-west-1a,eu-west-1c"
  }
}
variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.123.0.0/16"
}
variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnets"
    type = "map"
    default = {
      us-east-1a = "10.123.0.0/24"
      us-east-1c = "10.123.2.0/24"
      eu-west-1a = "10.123.4.0/24"
      eu-west-1c = "10.123.6.0/24"
    }
}
variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnets"
    type = "map"
    default = {
      us-east-1a = "10.123.1.0/24"
      us-east-1c = "10.123.3.0/24"
      eu-west-1a = "10.123.5.0/24"
      eu-west-1c = "10.123.7.0/24"
    }
}
