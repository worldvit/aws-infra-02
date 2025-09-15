# resource "aws_security_group" "allow_web" {
#   vpc_id = var.itskillboost_vpc_id
#   name = "allow_web"
#   tags = {
#     Name      = "allow-web-sg"
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   dynamic "ingress" {
#     for_each = var.aws_sg
#     content {
#       description = ingress.value.description
#       from_port = ingress.value.port
#       to_port = ingress.value.port
#       protocol = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }
# }

# resource "aws_security_group" "allow_alb" {
#   vpc_id = var.itskillboost_vpc_id
#   name = "allow_alb"
#   tags = {
#     Name      = "allow_alb-sg"
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   dynamic "ingress" {
#     for_each = var.alb_sg
#     content {
#       description = ingress.value.description
#       from_port = ingress.value.port
#       to_port = ingress.value.port
#       protocol = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }
# }

resource "aws_security_group" "bastion" {
  vpc_id = var.itskillboost_vpc_id
  name = "bastion"
  tags = {
    Name      = "bastion"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.bastion_sg
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

# // security group for elb
# resource "aws_security_group" "elb" {
#   name = "elb"
#   vpc_id = var.itskillboost_vpc_id
#   tags = { Name = "elb" }
# }


# resource "aws_security_group_rule" "elb-ingress" {
#   security_group_id = aws_security_group.elb.id
#   type = "ingress"
#   from_port = 80
#   to_port = 80
#   protocol = "tcp"
#   cidr_blocks = [ "0.0.0.0/0"]
# }


# resource "aws_security_group_rule" "elb-egress" {
#   security_group_id = aws_security_group.elb.id
#   type = "egress"
#   from_port = 0
#   to_port = 0
#   protocol = "-1"
#   cidr_blocks = [ "0.0.0.0/0"]
# }

# =============================
# 데이터 소스: AWS CloudFront 서비스의 공식 IP 주소 목록을 가져옵니다.
# data "aws_managed_prefix_list" "cloudfront" {
#   name = "com.amazonaws.global.cloudfront.origin-facing"
# }

# ----------------------------------------------------
# 1. Web Server (EC2)용 보안 그룹
# Session Manager를 사용하므로 SSH(22) Ingress 규칙이 필요 없습니다.
# ----------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.itskillboost_vpc_id

  tags = {
    Name = "web-server-sg"
  }
}

# Ingress Rule: ALB로부터의 HTTP(80) 트래픽 허용
resource "aws_security_group_rule" "web_ingress_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow HTTP traffic from ALB"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.web_sg.id
}

# Egress Rule: 모든 아웃바운드 트래픽 허용 (SSM Agent 통신 등을 위해 필요)
resource "aws_security_group_rule" "web_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}


# ----------------------------------------------------
# 2. Application Load Balancer (ALB)용 보안 그룹
# (이전과 동일하게 유지됩니다)
# ----------------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow traffic from CloudFront"
  vpc_id      = var.itskillboost_vpc_id

  tags = {
    Name = "alb-sg"
  }
}

# Ingress Rules from CloudFront
resource "aws_security_group_rule" "alb_ingress_http_from_cloudfront" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "Allow HTTP from CloudFront"
  # prefix_list_ids   = [var.cloudfront_ip_ranges.id]
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_ingress_https_from_cloudfront" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow HTTPS from CloudFront"
  # prefix_list_ids   = [var.cloudfront_ip_ranges[*].id]
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# Egress Rule
resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}