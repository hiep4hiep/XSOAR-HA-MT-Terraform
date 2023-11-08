# Create Load Balancer for XSOAR Main app servers
resource "aws_security_group" "xsoar_main_lb" {
  name        = "${var.deployment_prefix}-xsoar-main-lb"
  description = "HTTPS to xsoar app"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.current.cidr_block,
      "130.41.199.0/24"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "xsoar_main_lb" {
  name               = "${var.deployment_prefix}-xsoar-app-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.aws_subnet_az1,var.aws_subnet_az2,var.aws_subnet_az3]
  security_groups = [aws_security_group.xsoar_main_lb.id]
  enable_http2 = true
}

resource "aws_lb_target_group" "xsoar_main_group" {
  name        = "${var.deployment_prefix}-xsoar-app-lb-target-group"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.aws_vpc
  health_check {
    enabled = true
    protocol = "HTTPS"
    port     = "443"
    path     = "/health"
    matcher  = "200"
    timeout = 10
  }

  stickiness {
    type     = "source_ip"
  }
}

# Define target group attachment for EC2 instances
resource "aws_lb_target_group_attachment" "xsoar_app_01" {
  target_group_arn = aws_lb_target_group.xsoar_main_group.arn
  target_id        = aws_instance.xsoar_app_01.id 
  port             = 443
}

resource "aws_lb_target_group_attachment" "xsoar_app_02" {
  target_group_arn = aws_lb_target_group.xsoar_main_group.arn
  target_id        = aws_instance.xsoar_app_02.id 
  port             = 443
}

resource "aws_lb_target_group_attachment" "xsoar_app_03" {
  target_group_arn = aws_lb_target_group.xsoar_main_group.arn
  target_id        = aws_instance.xsoar_app_03.id 
  port             = 443
}

resource "aws_lb_listener" "xsoar_app_listener" {
  load_balancer_arn = aws_lb.xsoar_main_lb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xsoar_main_group.arn
  }
}

output "xsoar_main_lb" {
    value = aws_lb.xsoar_main_lb.dns_name
}