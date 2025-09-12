output "itskillboost-alb" {
    value = aws_lb.web-lb.dns_name
}
output "itskillboost-tg" {
    value = aws_lb_target_group.tg.arn
}