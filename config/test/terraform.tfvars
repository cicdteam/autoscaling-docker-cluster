#
# General
#
name            = "test-cluster"
region          = "eu-west-1"
public_key_path = "~/.ssh/id_rsa.pub"

#
# Manager's cluster config
#
cluster_instance_type  = "t2.micro"    # ec2 instance type for cluster nodes
cluster_size_min       = "0"
cluster_size_max       = "0"

docker_user            = "none"
docker_pass            = "none"
