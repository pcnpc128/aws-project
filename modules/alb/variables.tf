variable "name" {}
variable "port" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "environment" {}

