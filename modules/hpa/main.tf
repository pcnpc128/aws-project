terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      configuration_aliases = [ kubernetes ] 
    }
  }
}

# HPA(Horizontal Pod Autoscaler) 생성 - Deployment 등 CPU 사용률 기반 자동 확장
resource "kubernetes_horizontal_pod_autoscaler" "default" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    scale_target_ref {
      kind        = var.kind            # 예: Deployment, StatefulSet 등
      name        = var.target_name     # 대상 워크로드 이름
      api_version = "apps/v1"
    }
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.target_cpu_utilization
        }
      }
    }
  }
}

