resource "aws_security_group" "allowd_web" {
  vpc_id = var.itskillboost_vpc_id

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


// Security group for bastion host
resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "for bastion host server"
  vpc_id = var.itskillboost_vpc_id
  tags = { Name = "bastion" }
}


resource "aws_security_group_rule" "bastion-ingress" {
  security_group_id = aws_security_group.bastion.id
  type = "ingress"
  description = "allowed all for ssh"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}


resource "aws_security_group_rule" "bastion-egress" {
  security_group_id = aws_security_group.bastion.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
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
