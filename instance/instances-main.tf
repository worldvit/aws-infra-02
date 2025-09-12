// launch template에서 생성할 예정임
# ## ec2-WEB
# resource "aws_instance" "ec2-web01" {
#   # ami             = var.AMIS[var.AWS_REGION]
#   ami           = data.aws_ami.ubuntu-linux.id
#   instance_type   = var.ins_type
#   vpc_security_group_ids = [var.allowd_web]
#   subnet_id       = var.itskillboost-private-subnet-0
#   associate_public_ip_address = false
#   key_name = var.mykey_key_name
# #   user_data = data.template_file.user_data_01.rendered
#   user_data_base64 = filebase64("script-nginx-01.sh")
#   root_block_device {
#     volume_size = "8"
#     volume_type = "gp3"
#     tags = {
#       "Name" = "ec2-web01"
#     }
#   }

#   tags = {
#     "Name" = "ec2-web01"
#   }
# }


# ### ec2-WEB2
# resource "aws_instance" "ec2-web02" {
#   ami           = data.aws_ami.ubuntu-linux.id
#   instance_type   = var.ins_type
#   vpc_security_group_ids = [var.allowd_web]
#   subnet_id       = var.itskillboost-private-subnet-1
#   associate_public_ip_address = false
#   key_name = var.mykey_key_name
#   user_data_base64 = filebase64("script-nginx-02.sh")

#   root_block_device {
#     volume_size = "8"
#     volume_type = "gp3"
#     tags = {
#       "Name" = "ec2-web02"
#     }
#   }
#   tags = {
#     "Name" = "ec2-web02"
#   }
# }

### Bastion Host
resource "aws_instance" "ec2-bastion" {
  ami           = data.aws_ami.ubuntu-linux.id
  instance_type   = var.ins_type
  vpc_security_group_ids = [var.bastion]
  subnet_id       = var.itskillboost-public-subnet-0
  key_name = var.mykey_key_name
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
    tags = {
      "Name" = "ec2-bastion"
    }
  }
  tags = {
    "Name" = "ec2-bastion"
  }
}
