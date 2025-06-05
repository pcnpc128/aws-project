# 공통
variable "profile"         { default = "default" }
variable "environment"     { default = "prod" }
variable "db_name"         { default = "seoul-db" }
variable "db_engine"       { default = "mysql" }
variable "db_engine_version" { default = "8.0" }
variable "db_instance_class" { default = "db.t3.micro" }
variable "db_storage"      { default = 20 }
variable "db_username"     {
  type = string
  default = "root"
}
variable "db_password"     {
  type = string
  default = "1234qwer"
}
variable "cluster_version" { default = "1.29" }

# 서울
variable "seoul_region"           { default = "ap-northeast-2" }
variable "seoul_vpc_cidr"         { default = "10.1.0.0/16" }
variable "seoul_public_subnets"   { default = ["10.1.1.0/24", "10.1.2.0/24"] }
variable "seoul_private_subnets"  { default = ["10.1.11.0/24", "10.1.12.0/24"] }
variable "seoul_azs"              { default = ["ap-northeast-2a", "ap-northeast-2c"] }

# 도쿄
variable "tokyo_region"           { default = "ap-northeast-1" }
variable "tokyo_vpc_cidr"         { default = "10.2.0.0/16" }
variable "tokyo_public_subnets"   { default = ["10.2.1.0/24", "10.2.2.0/24"] }
variable "tokyo_private_subnets"  { default = ["10.2.11.0/24", "10.2.12.0/24"] }
variable "tokyo_azs"              { default = ["ap-northeast-1a", "ap-northeast-1c"] }

