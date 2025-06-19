# 내부 RDS용 프라이빗 레코드 (모든 리전에서 접근 가능)

resource "aws_route53_record" "rds_primary" {
  zone_id = var.private_zone_id
  name    = "sr.2whhosting.com"
  type    = "CNAME"
  ttl     = 30
  records = [var.seoul_rds_endpoint]
}

resource "aws_route53_record" "rds_secondary" {
  zone_id = var.private_zone_id
  name    = "tr.2whhosting.com"
  type    = "CNAME"
  ttl     = 30
  records = [var.tokyo_rds_endpoint]
}

# VPC 연결 (서울/도쿄 모두 단일 프라이빗 존에 연결)
resource "aws_route53_zone_association" "seoul_assoc" {
  vpc_id     = var.vpc_id["seoul"]
  zone_id    = var.private_zone_id
  vpc_region = "ap-northeast-2"
}

resource "aws_route53_zone_association" "tokyo_assoc" {
  vpc_id     = var.vpc_id["tokyo"]
  zone_id    = var.private_zone_id
  vpc_region = "ap-northeast-1"
}

# Global Accelerator와 연동된 전역 애플리케이션 DNS
resource "aws_route53_record" "app_global_dns" {
  zone_id = var.public_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.ga_dns
    zone_id                = "Z2BJ6XQ5FK7U4H" # Global Accelerator 고정 Zone ID
    evaluate_target_health = false
  }
}
