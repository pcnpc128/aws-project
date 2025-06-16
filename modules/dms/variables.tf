# DMS 복제 인스턴스 이름
variable "replication_instance_id" {}

# 인스턴스 클래스 (예: dms.t3.medium)
variable "replication_instance_class" {}

# 스토리지 용량 (GB)
variable "allocated_storage" {
  default = 20
}

# DMS 인스턴스에 적용할 보안 그룹 ID 리스트
variable "security_group_ids" {
  type = list(string)
}

# DMS 인스턴스를 배치할 프라이빗 서브넷 ID 리스트
variable "private_subnet_ids" {
  type = list(string)
}

# 공통 태그
variable "tags" {
  type = map(string)
}

# 소스 DB 정보 (도쿄 RDS MySQL)
variable "source_db" {
  type = object({
    host     = string
    port     = number
    db_name  = string
    username = string
    password = string
  })
}

# 타겟 DB 정보 (온프레미스 MySQL)
variable "target_db" {
  type = object({
    host     = string
    port     = number
    db_name  = string
    username = string
    password = string
  })
}

