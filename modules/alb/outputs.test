# ALB의 DNS 이름 (서비스 접근 주소)
output "alb_dns_name" {
  description = "생성된 ALB의 DNS 이름 (접속 주소)"
  value       = aws_lb.this.dns_name
}

# ALB의 ARN
output "alb_arn" {
  description = "ALB 리소스의 ARN (고유 식별자)"
  value       = aws_lb.this.arn
}

# 타깃 그룹 ARN
output "target_group_arn" {
  description = "ALB Target Group의 ARN"
  value       = aws_lb_target_group.this.arn
}

