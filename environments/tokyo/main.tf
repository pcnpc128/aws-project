provider "aws" {
  region  = var.region
  profile = var.profile
}

# ---- VPC ----
module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

# ---- EKS ----
module "eks" {
  source          = "../../modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
}

# ---- ECR ----
module "ecr" {
  source      = "../../modules/ecr"
  name        = var.ecr_repo_name
  environment = var.environment
}

# ---- ALB ----
resource "aws_security_group" "alb_sg" {
  name   = "${var.project_name}-alb-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "alb" {
  source           = "../../modules/alb"
  name             = "${var.project_name}-alb"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
  port             = 80
  environment      = var.environment
  security_groups  = [aws_security_group.alb_sg.id]
}

# ---- Autoscaler, HPA, Monitoring 동일 ----
module "autoscaler" { source = "../../modules/autoscaler"; namespace = "kube-system" }
module "hpa" {
  source                  = "../../modules/hpa"
  name                    = var.hpa_name
  namespace               = "default"
  target_name             = var.hpa_target_name
  min_replicas            = 3
  max_replicas            = 10
  target_cpu_utilization  = 30
}
data "aws_eks_cluster_auth" "auth" { name = module.eks.cluster_name }
module "monitoring" {
  source               = "../../modules/monitoring"
  namespace            = "monitoring"
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_ca       = module.eks.cluster_ca
  eks_token            = data.aws_eks_cluster_auth.auth.token
}

# ---- RDS (Cross-region Read Replica, 다중 AZ) ----
resource "aws_security_group" "db" {
  name   = "${var.project_name}-db-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.db_allowed_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "rds" {
  source               = "../../modules/rds"
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_storage
  username             = var.db_username
  password             = var.db_password
  private_subnet_ids   = module.vpc.private_subnet_ids
  security_group_ids   = [aws_security_group.db.id]
  create_primary       = false
  create_replica       = true
  replicate_source_arn = var.seoul_rds_arn    # 반드시 서울 RDS output을 받아 전달
}
