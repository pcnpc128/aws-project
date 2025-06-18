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

output "alb_hostname" {
  description = "Ingress Controller가 생성한 ALB 도메인"
  value       = kubernetes_ingress_v1.app_ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "deployment_name" {
  description = "Name of the Kubernetes Deployment"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "service_port" {
  description = "Exposed port of the Kubernetes Service"
  value       = kubernetes_service.app_svc.spec[0].port[0].port
}

output "container_image" {
  description = "Deployed container image"
  value       = kubernetes_deployment.app.spec[0].template[0].spec[0].container[0].image
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  value = module.eks.oidc_provider
}

output "cluster_oidc_thumbprint" {
  value = data.tls_certificate.oidc_cert.certificates[0].sha1_fingerprint
}
