#variable "seoul_alb_arn" {}
#variable "tokyo_alb_arn" {}
variable "name" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "endpoints" {
  type = map(string)
}
