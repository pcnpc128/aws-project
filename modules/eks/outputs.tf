output "cluster_name" {
  description = "EKS 클러스터 이름"
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS 클러스터 API 서버 엔드포인트"
  value = module.eks.cluster_endpoint
}

output "cluster_ca" {
  description = "클러스터 인증서(base64)"
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "EKS 클러스터의 OIDC Issuer URL"
  value = module.eks.cluster_oidc_issuer_url
}

data "tls_certificate" "oidc_thumbprint" {
  url = module.eks.cluster_oidc_issuer_url
}

output "cluster_oidc_thumbprint" {
  description = "OIDC 프로바이더의 Thumbprint (IAM OIDC provider 생성 시 사용)"
  value = data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint
}
