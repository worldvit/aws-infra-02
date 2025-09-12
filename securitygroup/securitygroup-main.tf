resource "aws_security_group" "allow_web" {
  vpc_id = var.itskillboost_vpc_id
  name = "allow_web"
  tags = {
    Name      = "allow-web-sg"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.aws_sg
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_security_group" "allow_alb" {
  vpc_id = var.itskillboost_vpc_id
  name = "allow_alb"
  tags = {
    Name      = "allow_alb-sg"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.alb_sg
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

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

// security group for elb
resource "aws_security_group" "elb" {
  name = "elb"
  vpc_id = var.itskillboost_vpc_id
  tags = { Name = "elb" }
}


resource "aws_security_group_rule" "elb-ingress" {
  security_group_id = aws_security_group.elb.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0"]
}


resource "aws_security_group_rule" "elb-egress" {
  security_group_id = aws_security_group.elb.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
}