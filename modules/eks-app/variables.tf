variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  type        = string
}

variable "cluster_ca" {
  description = "Base64 encoded EKS cluster CA certificate"
  type        = string
}

variable "aws_region" {
  description = "AWS region of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "EKS가 배포될 VPC ID"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
  default     = "default"
}

variable "replica_count" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 2
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
}

variable "db_host" {
  description = "Hostname of the database"
  type        = string
}

variable "db_port" {
  description = "Port number of the database"
  type        = string
  default     = "3306"
}

variable "container_port" {
  description = "Port that the application container listens on"
  type        = number
  default     = 8080
}

variable "service_port" {
  description = "Port number the service exposes"
  type        = number
  default     = 80
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}
