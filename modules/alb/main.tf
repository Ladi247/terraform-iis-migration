resource "aws_lb" "iis_alb" {

  name               = "iis-migration-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnet_ids

  depends_on = [
    var.internet_gateway
  ]

}

resource "aws_lb_target_group" "iis_tg" {

  name     = "iis-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {

    path = "/"
    port = "8080"

  }
}

/* resource "aws_lb_target_group_attachment" "iis_attachment" {

  target_group_arn = aws_lb_target_group.iis_tg.arn
  target_id        = var.instance_id
  port             = 8080

} */

resource "aws_lb_listener" "iis_listener" {

  load_balancer_arn = aws_lb.iis_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.iis_tg.arn

  }

}

/* resource "aws_lb" "iis_alb" {

  name               = "iis-migration-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = [var.subnet_id]

} */