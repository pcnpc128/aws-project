#output "seoul_alb_dns"    { value = module.seoul_alb.alb_dns_name }
output "seoul_rds_arn"    { value = module.seoul_rds.primary_rds_arn }
#output "tokyo_alb_dns"    { value = module.tokyo_alb.alb_dns_name }
output "tokyo_rds_arn"    { value = module.tokyo_rds.primary_rds_arn }
#output "global_accel_dns" { value = module.global_accelerator.accelerator_dns }
output "seoul_cluster_name"    { value = module.seoul_eks.cluster_name }
output "seoul_cluster_endpoint"  { value = module.seoul_eks.cluster_endpoint }
output "tokyo_cluster_name"    { value = module.tokyo_eks.cluster_name }
output "tokyo_cluster_endpoint"  { value = module.tokyo_eks.cluster_endpoint }

