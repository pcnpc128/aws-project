terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws ]
    }
  }
}

# 컨테이너 이미지를 저장하는 ECR(Elastic Container Registry) 리포지토리 생성
resource "aws_ecr_repository" "app" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = true                                 # 이미지 푸시 시 취약점 자동 검사
  }

  tags = {
    Name        = var.name
  }
}

