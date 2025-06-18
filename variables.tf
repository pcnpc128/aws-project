# 공통
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
variable "domain_name" { default = "abnormal-trust.click" }

variable "route53_zone_id" { default = "Z0515787BIQI11V01WCO" }

# 서울
variable "seoul_vpc_cidr"         { default = "10.1.0.0/16" }
variable "seoul_public_subnets"   { default = ["10.1.1.0/24", "10.1.2.0/24"] }
variable "seoul_private_subnets"  { default = ["10.1.11.0/24", "10.1.12.0/24"] }
variable "seoul_azs"              { default = ["ap-northeast-2a", "ap-northeast-2c"] }

# 도쿄
variable "tokyo_vpc_cidr"         { default = "10.2.0.0/16" }
variable "tokyo_public_subnets"   { default = ["10.2.1.0/24", "10.2.2.0/24"] }
variable "tokyo_private_subnets"  { default = ["10.2.11.0/24", "10.2.12.0/24"] }
variable "tokyo_azs"              { default = ["ap-northeast-1a", "ap-northeast-1c"] }

# 추가된 변수들
variable "region" {
  description = "배포 대상 AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "myapp-seoul"
}

variable "vpc_id" {
  description = "EKS가 배포될 VPC ID"
  type        = map(string)
  default     = {
    seoul = "vpc-xxxxxxxxxxxxxxxxx"
    tokyo = "vpc-yyyyyyyyyyyyyyyyy"
  }
}

variable "app_name" {
  description = "애플리케이션 이름"
  type        = string
  default     = "myapp"
}

variable "app_image" {
  description = "ECR에 저장된 애플리케이션 이미지"
  type        = string
  default     = "501257812675.dkr.ecr.ap-northeast-2.amazonaws.com/my-node-app:latest"
}

variable "db_host" {
  description = "접속할 DB 호스트명"
  type        = string
  default     = "rds.myapp.com"
}

variable "namespace" {
  description = "Kubernetes 네임스페이스"
  type        = string
  default     = "default"
}

variable "replica_count" {
  description = "파드 복제 수"
  type        = number
  default     = 2
}

variable "db_port" {
  description = "DB 포트"
  type        = string
  default     = "3306"
}

variable "container_port" {
  description = "컨테이너 내부 포트"
  type        = number
  default     = 8080
}

variable "service_port" {
  description = "서비스가 외부에 노출할 포트"
  type        = number
  default     = 80
}

# Route53 연동용 추가 변수
variable "seoul_rds_endpoint" {
  description = "서울 RDS 엔드포인트 (FQDN 형식이어야 함)"
  type        = string
  default     = "mydb-seoul.cluster-abcdefghijk.ap-northeast-2.rds.amazonaws.com"
}

variable "tokyo_rds_endpoint" {
  description = "도쿄 RDS 엔드포인트 (FQDN 형식이어야 함)"
  type        = string
  default     = "mydb-tokyo.cluster-abcdefghijk.ap-northeast-1.rds.amazonaws.com"
}

variable "domain" {
  description = "Global DNS 이름 (예: www.abnormal-trust.click)"
  type        = string
  default     = "www.abnormal-trust.click"
}

variable "ga_dns" {
  description = "Global Accelerator DNS 이름"
  type        = string
  default     = "a1b2c3d4e5f6g7.cloudfront.net"
}

# App 모듈 전달용
variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "app_service_name" {
  description = "애플리케이션 서비스 이름"
  type        = string
  default     = "myapp-svc"
}
