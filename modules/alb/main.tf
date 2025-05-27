# 보안 그룹 생성 - ALB용
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Application Load Balancer용 보안 그룹"
  vpc_id      = var.vpc_id

  # 인바운드 규칙: 포트 80 허용 (HTTP)
  ingress {
    description = "HTTP 접근 허용"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 인바운드 규칙: 포트 443 허용 (HTTPS) - 선택
  ingress {
    description = "HTTPS 접근 허용"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 아웃바운드 규칙: 전체 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

# Target Group 생성 (Lambda, EC2, ECS 등 연결 대상)
resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = 80                        # 트래픽을 전달할 대상 포트
  protocol    = "HTTP"                    # 대상 그룹 통신 프로토콜
  vpc_id      = var.vpc_id
  target_type = var.target_type          # 대상 유형 (ip, instance, lambda 등)

  health_check {
    path                = var.health_check_path     # 헬스체크 경로
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

# HTTP 리스너에 타깃 그룹 연결 (정적 리스너 Rule)
resource "aws_lb_listener_rule" "default" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100  # 우선순위

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/*"] # 모든 경로를 처리
    }
  }
}

# Application Load Balancer 생성
resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false  # 외부 접근 가능한 ALB
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids         # 퍼블릭 서브넷에 배포
  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-alb"
  }
}

# 기본 리스너 생성 (포트 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  # 기본 응답: 404 (타깃 그룹 없이도 생성 가능)
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

