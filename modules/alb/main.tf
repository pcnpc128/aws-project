# ALB(Application Load Balancer) 및 Target Group, Listener 리소스 정의
resource "aws_lb" "app" {
  name               = var.name
  internal           = false                                 # 외부 트래픽 허용
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  tags = {
    Environment = var.environment
    Name        = var.name
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.name}-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                                         # EKS용은 일반적으로 ip

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

