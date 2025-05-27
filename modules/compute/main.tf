# Launch Template: EC2 인스턴스 생성 템플릿
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami_id           # 사용할 AMI ID
  instance_type = var.instance_type    # EC2 타입

  user_data = base64encode(file(var.user_data_file))  # 초기 부트스트랩 스크립트

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]  # EC2에 연결할 SG
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-instance"
    }
  }
}

# Auto Scaling Group: EC2 자동 생성/스케일링 그룹
resource "aws_autoscaling_group" "this" {
  name                      = "${var.name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids              # 배포할 Subnet들
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns              # ALB Target Group과 연결

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }
}

