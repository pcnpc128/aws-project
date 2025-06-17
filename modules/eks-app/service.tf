resource "kubernetes_service" "app_svc" {
  provider = kubernetes.eks

  metadata {
    name      = "${var.app_name}-svc"
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = "ClusterIP" # 또는 "NodePort" 선택
  }
}
