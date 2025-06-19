variable "public_zone_id" {
  type = string
  default = "Z0515787BIQI11V01WCO"
}

variable "private_zone_id" {
  type = string
}

variable "seoul_rds_endpoint" {
  type = string
}

variable "tokyo_rds_endpoint" {
  type = string
}

variable "domain" {
  type = string
}

variable "ga_dns" {
  type = string
}

variable "vpc_id" {
  description = "EKS가 속한 VPC ID"
  type        = map(string)
}
