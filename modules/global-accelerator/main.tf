resource "aws_globalaccelerator_accelerator" "this" {
  name               = var.name
  ip_address_type    = "IPV4"
  enabled            = true
}

resource "aws_globalaccelerator_listener" "this" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.arn
  protocol        = "TCP"
  port_ranges {
    from_port = var.listener_port
    to_port   = var.listener_port
  }
}

resource "aws_globalaccelerator_endpoint_group" "seoul" {
  listener_arn = aws_globalaccelerator_listener.this.arn
  endpoint_group_region = "ap-northeast-2"

  endpoint_configuration {
    endpoint_id = var.endpoints["seoul"]
    weight      = 100
  }
}

resource "aws_globalaccelerator_endpoint_group" "tokyo" {
  listener_arn = aws_globalaccelerator_listener.this.arn
  endpoint_group_region = "ap-northeast-1"

  endpoint_configuration {
    endpoint_id = var.endpoints["tokyo"]
    weight      = 0
  }
}
