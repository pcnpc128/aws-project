variable "app_name" {
  description = "앱 이름 및 레이블로 사용됨"
  type        = string
}

variable "namespace" {
  description = "배포할 Kubernetes 네임스페이스"
  type        = string
  default     = "default"
}

variable "replica_count" {
  description = "Pod 수 (HPA 이전의 기본 값)"
  type        = number
  default     = 2
}

variable "app_image" {
  description = "ECR에서 가져올 앱 컨테이너 이미지 경로"
  type        = string
}

variable "db_host" {
  description = "접속할 DB 호스트 (예: rds.2whhosting.com)"
  type        = string
}

variable "db_port" {
  description = "DB 포트 번호"
  type        = string
  default     = "3306"
}

variable "container_port" {
  description = "앱 컨테이너가 사용하는 포트"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  description = "EKS 클러스터 이름 (Cluster Autoscaler용)"
  type        = string
}

variable "region" {
  description = "EKS 클러스터가 위치한 AWS 리전"
  type        = string
}

variable "vpc_id" {
  description = "EKS 클러스터가 속한 VPC ID"
  type        = string
}

variable "app_service_name" {
  description = "Ingress에서 참조할 서비스 이름"
  type        = string
}

variable "cluster_endpoint" {}
variable "cluster_ca" {}
