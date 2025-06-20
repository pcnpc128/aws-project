provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"
}

provider "kubernetes" {
  alias                  = "seoul"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--region", "ap-northeast-2", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  alias = "seoul"
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--region", "ap-northeast-2", "--cluster-name", var.cluster_name]
    }
  }
}

module "eks_app_seoul" {
  source = "../../modules/eks-app"

  providers = {
    aws            = aws.seoul
    kubernetes.eks = kubernetes.seoul
    helm.eks       = helm.seoul
  }

  app_name        = "myapp"
  app_image       = var.app_image
  cluster_name    = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_ca       = var.cluster_ca
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
  cluster_oidc_thumbprint = var.cluster_oidc_thumbprint
  aws_region       = "ap-northeast-2"
  db_host          = var.db_host
  vpc_id           = var.vpc_id
}
