output "allow_web" {
  value = aws_security_group.allow_web.id
}

output "bastion" {
  value = aws_security_group.bastion.id
}

output "allow_alb" {
  value = aws_security_group.allow_alb.id
}