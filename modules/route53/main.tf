# 내부 RDS용 프라이빗 레코드 (모든 리전에서 접근 가능)
resource "aws_route53_record" "rds_internal" {
  zone_id = "Z0051881FLTR38PKBIJ"  # 2whhosting.com 프라이빗 호스팅 존 ID
  name    = "rds.2whhosting.com"
  type    = "CNAME"
  ttl     = 30
  records = [var.seoul_rds_endpoint]
}

# 헬스체크 - 서울 RDS
resource "aws_route53_health_check" "rds_seoul" {
  type              = "TCP"
  port              = 3306
  fqdn              = var.seoul_rds_endpoint
  failure_threshold = 3
  request_interval  = 30
}

# Failover 레코드: Primary - 서울
resource "aws_route53_record" "rds_primary" {
  zone_id = var.route53_zone_id
  name    = "rds.myapp.com"
  type    = "CNAME"

  set_identifier = "seoul-primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  ttl             = 30
  records         = [var.seoul_rds_endpoint]
  health_check_id = aws_route53_health_check.rds_seoul.id
}

# Failover 레코드: Secondary - 도쿄
resource "aws_route53_record" "rds_secondary" {
  zone_id = var.route53_zone_id
  name    = "rds.myapp.com"
  type    = "CNAME"

  set_identifier = "tokyo-fallback"
  failover_routing_policy {
    type = "SECONDARY"
  }

  ttl     = 30
  records = [var.tokyo_rds_endpoint]
}

# VPC 연결 (서울/도쿄 모두 단일 프라이빗 존에 연결)
resource "aws_route53_zone_association" "seoul_assoc" {
  vpc_id     = var.vpc_id["seoul"]
  zone_id    = "Z0051881FLTR38PKBIJ"
  vpc_region = "ap-northeast-2"
}

resource "aws_route53_zone_association" "tokyo_assoc" {
  vpc_id     = var.vpc_id["tokyo"]
  zone_id    = "Z0051881FLTR38PKBIJ"
  vpc_region = "ap-northeast-1"
}

# Global Accelerator와 연동된 전역 애플리케이션 DNS
resource "aws_route53_record" "app_global_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.ga_dns
    zone_id                = "Z2BJ6XQ5FK7U4H" # Global Accelerator 고정 Zone ID
    evaluate_target_health = false
  }
}
