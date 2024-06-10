resource "aws_security_group" "alb_sg" {
  name        = "${var.app_name}-${var.env}-alb-security-group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "${var.app_name}-${var.env}-alb"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.app_name}-${var.env}-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

// TODO: HTTPS
// https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
