resource "kubernetes_horizontal_pod_autoscaler" "app_hpa" {
  metadata {
    name      = "${var.app_name}-hpa"
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      kind       = "Deployment"
      name       = kubernetes_deployment.app.metadata[0].name
      api_version = "apps/v1"
    }

    min_replicas = 2
    max_replicas = 6

    target_cpu_utilization_percentage = 40
  }
}
