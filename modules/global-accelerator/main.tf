# Global Accelerator(글로벌 Anycast IP) 구성
resource "aws_globalaccelerator_accelerator" "this" {
  name            = var.name
  enabled         = true
  ip_address_type = "IPV4"
}

# 트래픽 리스너 생성 (HTTP 트래픽 기준)
resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  protocol        = "TCP"
  port_range {
    from_port = 80
    to_port   = 80
  }
}

# 서울 리전 ALB를 엔드포인트 그룹으로 등록
resource "aws_globalaccelerator_endpoint_group" "seoul" {
  listener_arn           = aws_globalaccelerator_listener.listener.arn
  endpoint_group_region  = "ap-northeast-2"
  endpoint_configuration {
    endpoint_id = var.seoul_alb_arn
    weight      = 100
  }
}

# 도쿄 리전 ALB를 엔드포인트 그룹으로 등록 (가중치로 우선순위 조정)
resource "aws_globalaccelerator_endpoint_group" "tokyo" {
  listener_arn           = aws_globalaccelerator_listener.listener.arn
  endpoint_group_region  = "ap-northeast-1"
  endpoint_configuration {
    endpoint_id = var.tokyo_alb_arn
    weight      = 0
  }
}

