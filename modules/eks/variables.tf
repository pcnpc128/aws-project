variable "cluster_name" {}
variable "cluster_version" { default = "1.29" }
variable "vpc_id" {}
variable "private_subnets" { type = list(string) }

