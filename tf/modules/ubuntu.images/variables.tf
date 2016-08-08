#
# External vars
#
variable "region" {}

#
# AMI variables
#
variable "ami_storage_type" {
  description = "AMI Storage Type. Valid options: instance-store, ebs-io1, ebs-ssd, ebs"
  default = "ebs"
}
variable "ami_ubuntu_distribution" {
  description = "Ubuntu distribution name"
  default = "trusty"
}
variable "ami_ubuntu_architecture" {
  description = "Ubuntu architecture. Valid options: amd64, i386"
  default = "amd64"
}
variable "ami_virtualization_type" {
  description = "Linux AMI Virtualization Types. Valid options: 'hvm, pv"
  default = "hvm"
}
