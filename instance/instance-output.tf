output "ec2-bastion" {
  value = aws_instance.ec2-bastion.id
}
output "ec2-web01_private_ip" {
  value = aws_instance.ec2-web01.private_ip
}
