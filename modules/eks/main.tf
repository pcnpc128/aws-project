terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws.this ] # 'this'는 호출자에서 넘기는 alias 이름
    }
  }
}

# AWS 공식 EKS 모듈 활용 (관리형 노드 그룹까지 자동 생성)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_capacity = 1
      max_capacity     = 6
      min_capacity     = 1
      instance_types   = ["t2.micro"]           # 실운영은 용량에 맞게
    }
  }
}

