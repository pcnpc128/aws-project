output "rds_failover_endpoint" {
  description = "RDS에 접근할 수 있는 공통 DNS 주소 (Failover)"
  value       = "rds.myapp.com"
}

output "rds_internal_dns" {
  description = "EKS 내부에서 사용할 RDS용 프라이빗 DNS"
  value       = aws_route53_record.rds_internal.name
}

output "app_dns" {
  description = "Global Accelerator를 사용하는 앱의 최종 접근 도메인"
  value       = aws_route53_record.app_global_dns.name
}

output "private_zone_id" {
  description = "프라이빗 호스팅 존 ID (2whhosting.com)"
  value       = "Z0051881FLTR38PKBIJ"
}
