output "allowd_web" {
  value = aws_security_group.allowd_web.id
}

output "bastion" {
  value = aws_security_group.bastion.id
}
