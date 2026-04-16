variable "cluster_name" {}
variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_ids" {
  type = list(string)
}

variable "node_group_name" {}