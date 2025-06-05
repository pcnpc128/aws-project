terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      configuration_aliases = [ helm.this ] # 'this'는 호출자에서 넘기는 alias 이름
    }
  }
}

# EKS 클러스터에 Cluster Autoscaler 설치 (Helm 차트)
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.namespace
  version    = "9.29.0"
  values     = [file("${path.module}/values-autoscaler.yaml")]
}

