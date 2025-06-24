terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws ]
    }
  }
}

# AWS 공식 EKS 모듈 활용 (관리형 노드 그룹까지 자동 생성)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  subnet_ids      = var.public_subnets
  vpc_id          = var.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_capacity = 1
      max_capacity     = 6
      min_capacity     = 1
      instance_types   = ["t2.micro"]           # 실운영은 용량에 맞게
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                 = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}"     = "owned"
      }
    }
  }
}

data "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}
