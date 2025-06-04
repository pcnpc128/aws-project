# EKS 클러스터에 Cluster Autoscaler 설치 (Helm 차트)
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.namespace
  version    = "9.29.0"
  values     = [file("${path.module}/values-autoscaler.yaml")]
}

