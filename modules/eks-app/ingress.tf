resource "kubernetes_ingress_v1" "app_ingress" {
  provider = kubernetes.eks
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme"                     = "internet-facing",
      "alb.ingress.kubernetes.io/target-type"               = "ip",
      "alb.ingress.kubernetes.io/listen-ports"              = jsonencode([{ "HTTP" = 80 }]),
      "alb.ingress.kubernetes.io/backend-protocol"          = "HTTP",
      "alb.ingress.kubernetes.io/group.name"                = var.app_name,
      "kubernetes.io/ingress.class"                         = "alb"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
#              name = var.app_service_name
              name = kubernetes_service.app_svc.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service.app_svc]
}
