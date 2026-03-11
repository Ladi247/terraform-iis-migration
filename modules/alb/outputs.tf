output "alb_dns_name" {
  value = aws_lb.iis_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.iis_tg.arn
}