// ELB
resource "aws_lb" "web-lb" {
  name = "web-lb"
  subnets = [
    var.itskillboost-public-subnet-0,
    var.itskillboost-public-subnet-1
   ]
   internal = false
   security_groups = [ var.allow_alb ]
   load_balancer_type = "application"
   enable_deletion_protection = false
   tags = { Name = "web-lb"}
}


// target group
resource "aws_lb_target_group" "tg" {
  name = "tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.itskillboost_vpc_id
  health_check {
    enabled = true
    port = 80
    interval = 15
    path = "/index.html"
    healthy_threshold = 2
    unhealthy_threshold = 3
    matcher = 200
  }
  tags = { Name = "tg" }
}

// AutoScaling에서 관리 예정
# // target group attachment
# resource "aws_lb_target_group_attachment" "tg-att1" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id = var.ec2-web01
#   port = 80
# }


# resource "aws_lb_target_group_attachment" "tg-att2" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id = var.ec2-web02
#   port = 80
# }

// listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.web-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
}
