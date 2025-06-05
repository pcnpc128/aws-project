variable "create_primary" {
  type = bool
}

variable "create_replica" {
  type = bool
}

variable "replicate_source_db" {
  type    = string
  default = null
}

variable "db_name" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}

variable "allocated_storage" {
  default = 20
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {}

variable "security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "db_username" {
  type = string
  default = "root"
}

variable "db_password" {
  type = string
  default = "1234qwer"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "default-rds"
    Environment = "dev"
  }
}

variable "description" {
  type = string
  default = "Managed RDS instance"
}
