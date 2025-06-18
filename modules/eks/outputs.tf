output "cluster_name"     { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_ca"       { value = module.eks.cluster_certificate_authority_data }
#output "oidc_provider_url" { value = module.eks.cluster_oidc_issuer_url }
#output "oidc_thumbprint" { value = module.eks.cluster_oidc_thumbprint }
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "tls_certificate" "oidc_thumbprint" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_oidc_thumbprint" {
  value = data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint
}
