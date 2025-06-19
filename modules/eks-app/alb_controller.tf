resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1"

  depends_on = [kubernetes_service_account.alb_controller_sa]

  set = [
    {
      name  = "clusterName"  # EKS 클러스터 이름
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.create"  # 서비스 계정 이름 (IRSA 구성 필요)
      value = "false"
    },
    {
      name  = "region"  # AWS 리전을 명시적으로 지정
      value = var.aws_region
    },
    {
      name  = "vpcId"  # VPC ID 지정 (선택사항, 일부 기능 필요 시)
      value = var.vpc_id
    },
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
    }
  ]
}
