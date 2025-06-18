terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws ]
    }
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}

data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
}

resource "kubernetes_deployment" "app" {
  provider = kubernetes.eks
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = var.app_image

          env {
            name  = "DB_HOST"
            value = var.db_host
          }

          env {
            name  = "DB_PORT"
            value = var.db_port
          }

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}
