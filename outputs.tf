#output "seoul_alb_dns"    { value = module.seoul_alb.alb_dns_name }
output "seoul_rds_arn"    { value = module.seoul_rds.primary_rds_arn }
#output "tokyo_alb_dns"    { value = module.tokyo_alb.alb_dns_name }
output "tokyo_rds_arn"    { value = module.tokyo_rds.primary_rds_arn }
#output "global_accel_dns" { value = module.global_accelerator.accelerator_dns }
output "seoul_cluster_name"    { value = module.seoul_eks.cluster_name }
output "seoul_cluster_endpoint"  { value = module.seoul_eks.cluster_endpoint }
output "tokyo_cluster_name"    { value = module.tokyo_eks.cluster_name }
output "tokyo_cluster_endpoint"  { value = module.tokyo_eks.cluster_endpoint }

# 서울 노드 그룹 IAM Role 이름
output "seoul_node_group_iam_role_name" {
  description = "IAM Role name for Seoul EKS node group"
  value       = module.seoul_eks.eks_managed_node_groups["default"].iam_role_name
}

# 서울 노드 그룹 IAM Role ARN
output "seoul_node_group_iam_role_arn" {
  description = "IAM Role ARN for Seoul EKS node group"
  value       = module.seoul_eks.eks_managed_node_groups["default"].iam_role_arn
}

# 도쿄 노드 그룹 IAM Role 이름
output "tokyo_node_group_iam_role_name" {
  description = "IAM Role name for Tokyo EKS node group"
  value       = module.tokyo_eks.eks_managed_node_groups["default"].iam_role_name
}

# 도쿄 노드 그룹 IAM Role ARN
output "tokyo_node_group_iam_role_arn" {
  description = "IAM Role ARN for Tokyo EKS node group"
  value       = module.tokyo_eks.eks_managed_node_groups["default"].iam_role_arn
}

# Cluster Autoscaler용 IRSA Role ARN (서울)
output "seoul_irsa_autoscaler_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler in Seoul"
  value       = module.seoul_irsa_autoscaler.iam_role_arn
}

# ALB Controller용 IRSA Role ARN (서울)
output "seoul_irsa_alb_controller_role_arn" {
  description = "IAM Role ARN for ALB Controller in Seoul"
  value       = module.seoul_irsa_alb_controller.iam_role_arn
}

# Cluster Autoscaler용 IRSA Role ARN (도쿄)
output "tokyo_irsa_autoscaler_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler in Tokyo"
  value       = module.tokyo_irsa_autoscaler.iam_role_arn
}

# ALB Controller용 IRSA Role ARN (도쿄)
output "tokyo_irsa_alb_controller_role_arn" {
  description = "IAM Role ARN for ALB Controller in Tokyo"
  value       = module.tokyo_irsa_alb_controller.iam_role_arn
}
