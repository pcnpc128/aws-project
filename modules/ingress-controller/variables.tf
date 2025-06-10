variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "service_name" {
  type = string
}

variable "service_port" {
  type = number
}
