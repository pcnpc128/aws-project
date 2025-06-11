output "app_name" {
  description = "배포된 앱 이름"
  value       = var.app_name
}

output "namespace" {
  description = "배포된 네임스페이스"
  value       = var.namespace
}

output "container_port" {
  description = "애플리케이션 컨테이너 포트"
  value       = var.container_port
}

output "app_service_name" {
  value = kubernetes_service.app_svc.metadata[0].name
}
