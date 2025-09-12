resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ami-instance
  instance_type = "t3.micro"

  vpc_security_group_ids = [var.allow_alb]
  key_name = var.mykey_key_name

  # 위에서 만든 스크립트 파일을 base64로 인코딩하여 전달
  user_data = filebase64("${path.module}/script-nginx-01.sh")
    # user_data = <<-EOF
    #     #!/bin/bash
    #     sleep 60
    #     sudo apt -y update
    #     sudo apt -y install nginx
    #     sudo systemctl enable --now nginx

    #     # AWS EC2 메타데이터 서비스에서 인스턴스 ID를 가져와서 index.html에 쓰기
    #     INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    #     echo "<h1>WebServer powered by Auto Scaling Group</h1><h2>Instance ID: $INSTANCE_ID</h2>" > /var/www/html/index.html
    # EOF
  # 인스턴스 식별을 위한 태그 설정
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-on-asg"
    }
  }
}

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
    id      = aws_launch_template.web_lt.id
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

resource "aws_route53_record" "www_cname" {
  zone_id = var.aws_route53_zone
  name    = "www3.itskillboost.com"
  type    = "CNAME"
  ttl     = 300
  records = [var.itskillboost-alb]

  lifecycle {
    create_before_destroy = "true"
  }
}