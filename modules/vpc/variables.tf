# VPC CIDR 블록 (기본값: 10.0.0.0/16)
variable "vpc_cidr" {
  description = "생성할 VPC의 CIDR 블록"
  type        = string
}

# 퍼블릭 서브넷 목록 (CIDR 블록 배열)
variable "public_subnets" {
  description = "퍼블릭 서브넷으로 사용할 CIDR 블록 목록"
  type        = list(string)
}

# 프라이빗 서브넷 목록 (CIDR 블록 배열)
variable "private_subnets" {
  description = "프라이빗 서브넷으로 사용할 CIDR 블록 목록"
  type        = list(string)
}

# 사용할 가용 영역 목록 (예: ap-northeast-2a, ap-northeast-2c)
variable "azs" {
  description = "서브넷을 배포할 AWS 가용 영역 목록"
  type        = list(string)
}

# 네이밍에 사용할 접두어 (리전명 또는 환경 구분용)
variable "name" {
  description = "리소스 이름 태그에 사용할 접두어"
  type        = string
}

