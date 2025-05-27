# VPC ID
variable "vpc_id" {
  description = "ALB가 속할 VPC의 ID"
  type        = string
}

# 퍼블릭 서브넷 ID 목록
variable "public_subnet_ids" {
  description = "ALB를 배포할 퍼블릭 서브넷 ID 목록"
  type        = list(string)
}

# 리소스 네이밍 접두어
variable "name" {
  description = "리소스 이름에 사용할 접두어"
  type        = string
}

# 대상 유형: instance, ip, lambda 중 선택
variable "target_type" {
  description = "타깃 그룹의 대상 유형 (instance, ip, lambda)"
  type        = string
  default     = "ip"
}

# 헬스체크 경로
variable "health_check_path" {
  description = "타깃 그룹 헬스체크에 사용할 경로"
  type        = string
  default     = "/"
}
