resource "aws_route53_record" "root_domain" {
  zone_id = var.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = var.ga_dns
    zone_id                = "Z2BJ6XQ5FK7U4H"  # Global Accelerator 고정 zone ID
    evaluate_target_health = false
  }
}
