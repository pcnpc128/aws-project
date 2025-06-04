variable "db_name" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "username" {}
variable "password" {}
variable "private_subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "create_primary" {
	type = bool
	default = false
}
variable "create_replica" {
	type = bool
	default = false
}
variable "replicate_source_arn" {
	type = string
	default = ""
}

