terraform {
  required_version = ">= 1.3.0"
}

provider "aws" {
  region  = var.seoul_region    # 기본 리전을 서울로 지정
  profile = var.profile
  alias   = "seoul"
}

provider "aws" {
  region  = var.tokyo_region
  profile = var.profile
  alias   = "tokyo"
}

# -----------------------------------
# 서울 리전 리소스 모듈
# -----------------------------------

module "seoul_vpc" {
  source          = "./modules/vpc"
  providers       = { aws.this = aws.seoul }
  vpc_cidr        = var.seoul_vpc_cidr
  public_subnets  = var.seoul_public_subnets
  private_subnets = var.seoul_private_subnets
  azs             = var.seoul_azs
}

module "seoul_alb_sg" {
  source   = "./modules/security-group"
  providers = { aws.this = aws.seoul }
  name     = "seoul-alb-sg"
  vpc_id   = module.seoul_vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
  description = "seoul-alb-security-group"
  tags = {
    Name        = "seoul-loadbalance-sg"
    Environment = var.environment
  }
}

module "seoul_alb" {
  source           = "./modules/alb"
  providers        = { aws.this = aws.seoul }
  name             = "myapp-seoul-alb"
  vpc_id           = module.seoul_vpc.vpc_id
  subnet_ids       = module.seoul_vpc.public_subnet_ids
  port             = 80
  environment      = var.environment
  security_groups  = [module.seoul_alb_sg.security_group_id]
}

module "seoul_eks" {
  source          = "./modules/eks"
  providers       = { aws.this = aws.seoul }
  cluster_name    = "myapp-seoul"
  cluster_version = var.cluster_version
  vpc_id          = module.seoul_vpc.vpc_id
  private_subnets = module.seoul_vpc.private_subnet_ids
}

module "seoul_ecr" {
  source      = "./modules/ecr"
  providers   = { aws.this = aws.seoul }
  name        = "myapp-seoul-ecr"
  environment = var.environment
}

module "seoul_rds_sg" {
  source   = "./modules/security-group"
  providers = { aws.this = aws.seoul }
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
    Environment = var.environment
  }

}

module "seoul_rds" {
  source               = "./modules/rds"
  providers            = { aws.this = aws.seoul }
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
  multi_az             = true
  create_primary       = true
  create_replica       = false
  tags                 = { Name = "seoul-primary-db", Environment = var.environment }
}

# -----------------------------------
# 도쿄 리전 리소스 모듈
# -----------------------------------

module "tokyo_vpc" {
  source          = "./modules/vpc"
  providers       = { aws.this = aws.tokyo }
  vpc_cidr        = var.tokyo_vpc_cidr
  public_subnets  = var.tokyo_public_subnets
  private_subnets = var.tokyo_private_subnets
  azs             = var.tokyo_azs
}

module "tokyo_alb_sg" {
  source   = "./modules/security-group"
  providers = { aws.this = aws.tokyo }
  name     = "tokyo-alb-sg"
  vpc_id   = module.tokyo_vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
  description = "tokyo-alb-security-group"
  tags = {
    Name        = "tokyo-loadbalance-sg"
    Environment = var.environment
  }

}

module "tokyo_alb" {
  source           = "./modules/alb"
  providers        = { aws.this = aws.tokyo }
  name             = "myapp-tokyo-alb"
  vpc_id           = module.tokyo_vpc.vpc_id
  subnet_ids       = module.tokyo_vpc.public_subnet_ids
  port             = 80
  environment      = var.environment
  security_groups  = [module.tokyo_alb_sg.security_group_id]
}


module "tokyo_eks" {
  source          = "./modules/eks"
  providers       = { aws.this = aws.tokyo }
  cluster_name    = "myapp-tokyo"
  cluster_version = var.cluster_version
  vpc_id          = module.tokyo_vpc.vpc_id
  private_subnets = module.tokyo_vpc.private_subnet_ids
}

module "tokyo_ecr" {
  source      = "./modules/ecr"
  providers   = { aws.this = aws.tokyo }
  name        = "myapp-tokyo-ecr"
  environment = var.environment
}

module "tokyo_rds_sg" {
  source   = "./modules/security-group"
  providers = { aws.this = aws.tokyo }
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
  description = "seoul-rds-security-group"
  tags = {
    Name        = "seoul-rds-sg"
    Environment = var.environment
  }

}

module "tokyo_rds" {
  source               = "./modules/rds"
  providers            = { aws.this = aws.tokyo }
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  private_subnet_ids   = module.tokyo_vpc.private_subnet_ids
  security_group_ids   = [module.tokyo_rds_sg.security_group_id]
  vpc_id               = module.tokyo_vpc.vpc_id
  create_primary       = false
  create_replica       = true
  multi_az             = true
  replicate_source_db  = module.seoul_rds.db_instance_id   # 서울 RDS output을 input으로 자동 연결!
  tags                 = { Name = "tokyo-readonly-replica", Environment = var.environment }
}

# -----------------------------------
# 글로벌 리소스 (Global Accelerator)
# -----------------------------------

module "global_accelerator" {
  source        = "./modules/global-accelerator"
  name          = "myapp-dr-accelerator"
  seoul_alb_arn = module.seoul_alb.alb_arn
  tokyo_alb_arn = module.tokyo_alb.alb_arn
}

