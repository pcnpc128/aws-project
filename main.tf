terraform {
  required_version = ">= 1.3.0"
}

provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"
}

#provider "kubernetes" {
#  alias                  = "seoul"
#  host                   = var.cluster_endpoint
#  cluster_ca_certificate = base64decode(var.cluster_ca)
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    command     = "aws"
#    args        = ["eks", "get-token", "--region", "ap-northeast-2", "--cluster-name", var.cluster_name]
#  }
#}

#provider "helm" {
#  alias = "seoul"
#  kubernetes {
#    host                   = var.cluster_endpoint
#    cluster_ca_certificate = base64decode(var.cluster_ca)
#    exec {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      command     = "aws"
#      args        = ["eks", "get-token", "--region", "ap-northeast-2", "--cluster-name", var.cluster_name]
#    }
#  }
#}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

#provider "kubernetes" {
#  alias                  = "tokyo"
#  host                   = var.cluster_endpoint
#  cluster_ca_certificate = base64decode(var.cluster_ca)
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    command     = "aws"
#    args        = ["eks", "get-token", "--region", "ap-northeast-1", "--cluster-name", var.cluster_name]
#  }
#}

#provider "helm" {
#  alias = "tokyo"
#  kubernetes {
#    host                   = var.cluster_endpoint
#    cluster_ca_certificate = base64decode(var.cluster_ca)
#    exec {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      command     = "aws"
#      args        = ["eks", "get-token", "--region", "ap-northeast-1", "--cluster-name", var.cluster_name]
#    }
#  }
#}


# -----------------------------------
# 서울 리전 리소스 모듈
# -----------------------------------

module "seoul_vpc" {
  source          = "./modules/vpc"
  providers       = { aws = aws.seoul }
  vpc_cidr        = var.seoul_vpc_cidr
  public_subnets  = var.seoul_public_subnets
  private_subnets = var.seoul_private_subnets
  azs             = var.seoul_azs
}

#module "seoul_alb_sg" {
#  source   = "./modules/security-group"
#  providers = { aws = aws.seoul }
#  name     = "seoul-alb-sg"
#  vpc_id   = module.seoul_vpc.vpc_id
#  ingress_rules = [
#    {
#      from_port   = 80
#      to_port     = 80
#      protocol    = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#  egress_rules = [
#    {
#      from_port   = 0
#      to_port     = 0
#      protocol    = "-1"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#  description = "seoul-alb-security-group"
#  tags = {
#    Name        = "seoul-loadbalance-sg"
#  }
#}

#module "seoul_alb" {
#  source           = "./modules/alb"
#  providers        = { aws = aws.seoul }
#  name             = "myapp-seoul-alb"
#  vpc_id           = module.seoul_vpc.vpc_id
#  subnet_ids       = module.seoul_vpc.public_subnet_ids
#  port             = 80
#  environment      = var.environment
#  security_groups  = [module.seoul_alb_sg.security_group_id]
#}

module "seoul_eks" {
  source          = "./modules/eks"
  providers       = { aws = aws.seoul }
  cluster_name    = "myapp-seoul"
  cluster_version = var.cluster_version
  vpc_id          = module.seoul_vpc.vpc_id
  public_subnets  = module.seoul_vpc.public_subnet_ids
}

#module "seoul_eks_app" {
#  source          = "./modules/eks-app"
#  providers = {
#    aws            = aws.seoul
#    kubernetes.eks = kubernetes.seoul
#    helm.eks       = helm.seoul
#  }
#  app_name        = "myapp"
#  app_image       = "501257812675.dkr.ecr.ap-northeast-2.amazonaws.com/my-node-app:latest"
#  cluster_name = module.seoul_eks.cluster_name
#  cluster_endpoint = module.seoul_eks.cluster_endpoint
#  cluster_ca       = module.seoul_eks.cluster_ca
#  cluster_oidc_issuer_url = module.seoul_eks.cluster_oidc_issuer_url
#  cluster_oidc_thumbprint = module.seoul_eks.cluster_oidc_thumbprint
#  aws_region       = "ap-northeast-2" 
#  db_host         = "sr.2whhosting.com"
#  vpc_id          = module.seoul_vpc.vpc_id
#}

#module "seoul_ecr" {
#  source      = "./modules/ecr"
#  providers   = { aws = aws.seoul }
#  name        = "myapp-seoul-ecr"
#  environment = var.environment
#}

module "seoul_rds_sg" {
  source   = "./modules/security-group"
  providers = { aws = aws.seoul }
  name     = "seoul-db-sg"
  vpc_id   = module.seoul_vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [module.seoul_vpc.vpc_cidr]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  description = "seoul-rds-security-group"
  tags = {
    Name        = "seoul-rds-sg"
  }

}

module "seoul_rds" {
  source               = "./modules/rds"
  providers            = { aws = aws.seoul }
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_storage
  db_username          = var.db_username
  db_password          = var.db_password
  private_subnet_ids   = module.seoul_vpc.private_subnet_ids
  vpc_id               = module.seoul_vpc.vpc_id
  security_group_ids   = [module.seoul_rds_sg.security_group_id]
#  multi_az             = true
  create_primary       = true
  create_replica       = false
  tags                 = { Name = "seoul-primary-db" }
}

# -----------------------------------
# 도쿄 리전 리소스 모듈
# -----------------------------------

module "tokyo_vpc" {
  source          = "./modules/vpc"
  providers       = { aws = aws.tokyo }
  vpc_cidr        = var.tokyo_vpc_cidr
  public_subnets  = var.tokyo_public_subnets
  private_subnets = var.tokyo_private_subnets
  azs             = var.tokyo_azs
}

#module "tokyo_alb_sg" {
#  source   = "./modules/security-group"
#  providers = { aws = aws.tokyo }
#  name     = "tokyo-alb-sg"
#  vpc_id   = module.tokyo_vpc.vpc_id
#  ingress_rules = [
#    {
#      from_port   = 80
#      to_port     = 80
#      protocol    = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#  egress_rules = [
#    {
#      from_port   = 0
#      to_port     = 0
#      protocol    = "-1"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#  description = "tokyo-alb-security-group"
#  tags = {
#    Name        = "tokyo-loadbalance-sg"
#  }
#
#}

#module "tokyo_alb" {
#  source           = "./modules/alb"
#  providers        = { aws = aws.tokyo }
#  name             = "myapp-tokyo-alb"
#  vpc_id           = module.tokyo_vpc.vpc_id
#  subnet_ids       = module.tokyo_vpc.public_subnet_ids
#  port             = 80
#  environment      = var.environment
#  security_groups  = [module.tokyo_alb_sg.security_group_id]
#}


module "tokyo_eks" {
  source          = "./modules/eks"
  providers       = { aws = aws.tokyo }
  cluster_name    = "myapp-tokyo"
  cluster_version = var.cluster_version
  vpc_id          = module.tokyo_vpc.vpc_id
  public_subnets  = module.tokyo_vpc.public_subnet_ids
}

#module "tokyo_eks_app" {
#  source          = "./modules/eks-app"
#  providers = {
#    aws            = aws.tokyo
#    kubernetes.eks = kubernetes.tokyo
#    helm.eks       = helm.tokyo
#  }
#  app_name        = "myapp"
#  app_image       = "501257812675.dkr.ecr.ap-northeast-1.amazonaws.com/my-node-app:latest"
#  cluster_name = module.tokyo_eks.cluster_name
#  cluster_endpoint = module.tokyo_eks.cluster_endpoint
#  cluster_ca       = module.tokyo_eks.cluster_ca
#  cluster_oidc_issuer_url = module.tokyo_eks.cluster_oidc_issuer_url
#  cluster_oidc_thumbprint = module.tokyo_eks.cluster_oidc_thumbprint
#  aws_region       = "ap-northeast-1" 
#  db_host         = "tr.2whhosting.com"
#  vpc_id          = module.tokyo_vpc.vpc_id
#}

#module "tokyo_ecr" {
#  source      = "./modules/ecr"
#  providers   = { aws = aws.tokyo }
#  name        = "myapp-tokyo-ecr"
#  environment = var.environment
#}

module "tokyo_rds_sg" {
  source   = "./modules/security-group"
  providers = { aws = aws.tokyo }
  name     = "tokyo-db-sg"
  vpc_id   = module.tokyo_vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [module.tokyo_vpc.vpc_cidr]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  description = "tokyo-rds-security-group"
  tags = {
    Name        = "tokyo-rds-sg"
  }

}

module "tokyo_rds" {
  source               = "./modules/rds"
  providers            = { aws = aws.tokyo }
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  private_subnet_ids   = module.tokyo_vpc.private_subnet_ids
  security_group_ids   = [module.tokyo_rds_sg.security_group_id]
  vpc_id               = module.tokyo_vpc.vpc_id
  create_primary       = false
  create_replica       = true
#  multi_az             = true
  replicate_source_db  = module.seoul_rds.primary_rds_arn   # 서울 RDS output을 input으로 자동 연결!
  tags                 = { Name = "tokyo-readonly-replica" }
}

#module "dms" {
#  source = "./modules/dms"
#  subnet_ids         = module.tokyo_vpc.private_subnet_ids
#  security_group_ids = [module.security_group.dms_sg_id]
#
#  source_db_host     = "192.168.1.11"
#  source_db_username = var.onprem_db_user
#  source_db_password = var.onprem_db_pass
#  source_db_name     = "your_source_db"
#
#  target_db_host     = module.tokyo_rds.endpoint
#  target_db_username = var.rds_db_user
#  target_db_password = var.rds_db_pass
#  target_db_name     = "your_target_db"
#}

# ---------------
#  글로벌 리소스 
# ---------------

#module "global_accelerator" {
#  source = "./modules/global-accelerator"
#  name = "myapp-global-accel"
#  endpoints = {
#    seoul = module.seoul_eks_app.alb_hostname != "" ? module.seoul_eks_app.alb_hostname : "dummy-seoul.alb"
#    tokyo = module.tokyo_eks_app.alb_hostname != "" ? module.tokyo_eks_app.alb_hostname : "dummy-tokyo.alb"
#  }
#
#  listener_port = 80
#}

module "route53" {
  source               = "./modules/route53"
  private_zone_id      = var.private_zone_id
  public_zone_id       = var.public_zone_id
  seoul_rds_endpoint   = module.seoul_rds.endpoint
  tokyo_rds_endpoint   = module.tokyo_rds.endpoint
#  domain               = var.domain
#  ga_dns               = module.global_accelerator.ga_dns
  vpc_id               = {
    seoul = module.seoul_vpc.vpc_id
    tokyo = module.tokyo_vpc.vpc_id
  }
}

module "seoul_irsa_autoscaler" {
  source = "./modules/irsa-role"
  providers            = { aws = aws.seoul }
  oidc_provider_arn     = module.seoul_eks.oidc_provider_arn
  oidc_issuer_url       = module.seoul_eks.cluster_oidc_issuer_url
  namespace             = "kube-system"
  service_account_name  = "cluster-autoscaler"
  role_name             = "seoul-cluster-autoscaler-role"
  policy_json           = file("${path.root}/policies/cluster-autoscaler-policy.json")
}

module "seoul_irsa_alb_controller" {
  source = "./modules/irsa-role"
  providers            = { aws = aws.seoul }
  oidc_provider_arn     = module.seoul_eks.oidc_provider_arn
  oidc_issuer_url       = module.seoul_eks.cluster_oidc_issuer_url
  namespace             = "kube-system"
  service_account_name  = "aws-load-balancer-controller"
  role_name             = "seoul-alb-controller-role"
  policy_json           = file("${path.root}/policies/alb-controller-policy.json")
}

module "tokyo_irsa_autoscaler" {
  source = "./modules/irsa-role"
  providers            = { aws = aws.tokyo }
  oidc_provider_arn     = module.tokyo_eks.oidc_provider_arn
  oidc_issuer_url       = module.tokyo_eks.cluster_oidc_issuer_url
  namespace             = "kube-system"
  service_account_name  = "cluster-autoscaler"
  role_name             = "tokyo-cluster-autoscaler-role"
  policy_json           = file("${path.root}/policies/cluster-autoscaler-policy.json")
}

module "tokyo_irsa_alb_controller" {
  source = "./modules/irsa-role"
  providers            = { aws = aws.tokyo }
  oidc_provider_arn     = module.tokyo_eks.oidc_provider_arn
  oidc_issuer_url       = module.tokyo_eks.cluster_oidc_issuer_url
  namespace             = "kube-system"
  service_account_name  = "aws-load-balancer-controller"
  role_name             = "tokyo-alb-controller-role"
  policy_json           = file("${path.root}/policies/alb-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "seoul-ecr_pull" {
  role     = module.seoul_eks.eks_managed_node_groups["default"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "tokyo-ecr_pull" {
  role     = module.tokyo_eks.eks_managed_node_groups["default"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
