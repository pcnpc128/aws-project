resource "aws_route53_record" "rds_internal" {
  zone_id = "Z0051881FLTR38PKBIJ"  # 2whhosting.com 프라이빗 호스팅 존 ID
  name    = "rds.2whhosting.com"
  type    = "CNAME"
  ttl     = 30
  records = [var.seoul_rds_endpoint]
}

resource "aws_route53_health_check" "rds_seoul" {
  type              = "TCP"
  port              = 3306
  fqdn              = var.seoul_rds_endpoint
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "rds_primary" {
  zone_id = var.route53_zone_id
  name    = "rds.myapp.com"
  type    = "CNAME"

  set_identifier = "seoul-primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  ttl              = 30
  records          = [var.seoul_rds_endpoint]
  health_check_id  = aws_route53_health_check.rds_seoul.id
}

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

resource "aws_route53_vpc_association_authorization" "private_zone_auth" {
  vpc_id  = var.vpc_id
  zone_id = "Z0051881FLTR38PKBIJ" # 2whhosting.com 프라이빗 호스팅 존
}

resource "aws_route53_zone_association" "private_zone_link" {
  vpc_id  = var.vpc_id
  zone_id = "Z0051881FLTR38PKBIJ"
  depends_on = [aws_route53_vpc_association_authorization.private_zone_auth]
}

resource "aws_route53_record" "app_global_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.ga_dns
    zone_id                = "Z2BJ6XQ5FK7U4H"
    evaluate_target_health = false
  }
}
