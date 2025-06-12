resource "kubernetes_service" "app_svc" {
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
      port        = 80
      target_port = var.container_port
    }

    type = "NodePort"
  }
}
