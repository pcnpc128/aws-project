output "rds_primary_dns" {
  description = "EKS 내부에서 사용할 Seoul RDS용 프라이빗 DNS"
  value       = aws_route53_record.rds_primary.name
}

output "rds_secondary_dns" {
  description = "EKS 내부에서 사용할 Tokyo RDS용 프라이빗 DNS"
  value       = aws_route53_record.rds_secondary.name
}

output "app_dns" {
  description = "Global Accelerator를 사용하는 앱의 최종 접근 도메인"
  value       = aws_route53_record.app_global_dns.name
}

output "private_zone_id" {
  description = "프라이빗 호스팅 존 ID (2whhosting.com)"
  value       = "Z0051881FLTR38PKBIJ"
}
