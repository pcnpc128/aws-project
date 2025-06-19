resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1"

  depends_on = [kubernetes_service.app_svc]

  set { # EKS 클러스터 이름
    name  = "clusterName"
    value = var.cluster_name
  }

  set { # 서비스 계정 이름 (IRSA 구성 필요)
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set { # AWS 리전을 명시적으로 지정
    name  = "region"
    value = var.aws_region
  }

  set { # VPC ID 지정 (선택사항, 일부 기능 필요 시)
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }
} 
