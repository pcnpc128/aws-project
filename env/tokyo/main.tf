provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

provider "kubernetes" {
  alias                  = "tokyo"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--region", "ap-northeast-1", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  alias = "tokyo"
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--region", "ap-northeast-1", "--cluster-name", var.cluster_name]
    }
  }
}

module "eks_app_tokyo" {
  source = "../../modules/eks-app"

  providers = {
    aws            = aws.tokyo
    kubernetes.eks = kubernetes.tokyo
    helm.eks       = helm.tokyo
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
