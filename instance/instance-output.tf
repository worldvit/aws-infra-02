output "ec2-bastion" {
  value = aws_instance.ec2-bastion.id
}
# output "ec2-web01_private_ip" {
#   value = aws_instance.ec2-web01.private_ip
# }

# output "ec2-web01"{
#   value = aws_instance.ec2-web01.id
# }

# output "ec2-web02"{
#   value = aws_instance.ec2-web01.id
# }

output "ami-instance" {
  value = data.aws_ami.ubuntu-linux.id
}