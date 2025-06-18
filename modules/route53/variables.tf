variable "route53_zone_id" {
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

variable "private_zone_id" {
  description = "프라이빗 호스팅 존 ID"
  type        = string
  default     = "Z0AAAAAAFLTR38PKSEOUL" # 실제 값으로 대체
}

variable "ga_dns" {
  type = string
}

variable "vpc_id" {
  description = "EKS가 속한 VPC ID"
  type        = map(string)
}
