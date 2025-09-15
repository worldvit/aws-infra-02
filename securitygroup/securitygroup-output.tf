# output "allow_web" {
#   value = aws_security_group.allow_web.id
# }

output "bastion" {
  value = aws_security_group.bastion.id
}

# output "allow_alb" {
#   value = aws_security_group.allow_alb.id
# }

# =======================
# Launch Template에서 사용할 Web Server(EC2) 보안 그룹 ID
output "web_sg_id" {
  description = "ID of the security group for web servers"
  value       = aws_security_group.web_sg.id
}

# Load Balancer에서 사용할 ALB 보안 그룹 ID
output "allow_alb" {
  description = "ID of the security group for the ALB"
  value       = aws_security_group.alb_sg.id
}