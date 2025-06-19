resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.29.0"

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = var.cluster_name
      },
      awsRegion = var.aws_region,
      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
        }
      },
      extraArgs = {
        "skip-nodes-with-local-storage" = "false",
        "scan-interval"                  = "10s",
        "balance-similar-node-groups"   = "true"
      },
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      },
      tolerations = [
        {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      ]
    })
  ]
}
