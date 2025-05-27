# 서울 리전에 대한 AWS Provider 정의
provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"  # 서울 리전
}

# 도쿄 리전에 대한 AWS Provider 정의
provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"  # 도쿄 리전
}

# 서울 리전용 VPC 모듈 호출
module "vpc_seoul" {
  source          = "./modules/vpc"               # VPC 모듈 위치
  providers       = { aws = aws.seoul }           # seoul provider 사용
  name            = "seoul"                       # 네이밍 접두사
  vpc_cidr        = "10.0.0.0/16"                 # VPC CIDR 블록
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"] # 퍼블릭 서브넷 CIDR
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"] # 프라이빗 서브넷 CIDR
  azs             = ["ap-northeast-2a", "ap-northeast-2c"] # 가용영역
}

# 도쿄 리전용 VPC 모듈 호출
module "vpc_tokyo" {
  source          = "./modules/vpc"
  providers       = { aws = aws.tokyo }           # tokyo provider 사용
  name            = "tokyo"
  vpc_cidr        = "10.1.0.0/16"
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
}

