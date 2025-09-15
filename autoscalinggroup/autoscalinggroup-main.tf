# resource "aws_launch_template" "web_lt" {
#   name_prefix   = "web-lt-"
#   image_id      = var.ami-instance
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [var.allow_alb]
#   key_name = var.mykey_key_name

#   user_data = filebase64("${path.module}/script-nginx-01.sh")

#   # 인스턴스 식별을 위한 태그 설정
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "web-on-asg"
#     }
#   }
# }

# ============
resource "aws_launch_template" "spot_worker_template" {
  name                   = "spot-worker-template"
  image_id               = var.ami-instance
  instance_type          = "t3.micro"
  key_name               = var.mykey_key_name
  vpc_security_group_ids = [var.web_sg_id]

  # 🚀 이 부분이 스팟 인스턴스를 요청하는 핵심 설정입니다.
  instance_market_options {
    market_type = "spot"

    spot_options {
      # 스팟 인스턴스가 중단될 때의 동작을 정의합니다.
      # "terminate" -> 인스턴스를 종료합니다. (ASG가 새 인스턴스를 다시 시작)
      instance_interruption_behavior = "terminate"

      # 최대 가격을 설정하지 않는 것이 Best Practice 입니다.
      # 설정하지 않으면 스팟 가격이 On-Demand 가격보다 낮을 때만 할당받게 되어
      # 불필요하게 비싼 비용을 지불하는 것을 방지하고 스팟 할당 확률을 높입니다.
    }
  }

  # User Data 등 기타 필요한 설정을 여기에 추가할 수 있습니다.
  user_data = filebase64("${path.module}/script-nginx-01.sh")

  tags = {
    Name = "spot-instance-from-lt"
  }
}

# ============
# 3. 오토스케일링 그룹 (Auto Scaling Group)
resource "aws_autoscaling_group" "web_asg" {
  name_prefix      = "web-asg-"
  min_size         = 2
  max_size         = 8
  desired_capacity = 4

  vpc_zone_identifier = [var.itskillboost-private-subnet-0,var.itskillboost-private-subnet-1]

  # 권장해주신 ELB 상태 검사 유형을 사용
#   health_check_type         = "ELB"
#   health_check_grace_period = 300

  # 위에서 만든 시작 템플릿을 사용
  launch_template {
    id      = aws_launch_template.spot_worker_template.id
    version = "$Latest"
  }

  # Target Group에 인스턴스를 자동 등록
  target_group_arns = [var.itskillboost-tg]

  # ASG 인스턴스에 태그 전파
  tag {
    key                 = "Name"
    value               = "web-on-asg"
    propagate_at_launch = true
  }
}

# cloudfront 사용으로 인한 폐쇄
# resource "aws_route53_record" "www_cname" {
#   zone_id = var.aws_route53_zone
#   name    = "www3.itskillboost.com"
#   type    = "CNAME"
#   ttl     = 300
#   records = [var.itskillboost-alb]

#   lifecycle {
#     create_before_destroy = "true"
#   }
# }