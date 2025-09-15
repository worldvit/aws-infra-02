variable "AWS_REGION" { default = "us-west-2" }
variable "ins_type" { default = "t3.micro" }
variable "itskillboost_vpc_id" {}
variable "PATH_TO_PUBLIC_KEY" { default = "keys/mykey.pub" }
variable "PATH_TO_PRIVATE_KEY" { default = "keys/mykey" }
variable "INSTANCE_USERNAME" { default = "ubuntu" }
variable "allow_alb" {}
variable "mykey_key_name" {}
variable "ami-instance" {}
variable "itskillboost-private-subnet-0" {}
variable "itskillboost-private-subnet-1" {}
variable "itskillboost-tg" {}
variable "aws_route53_zone" {}
variable "itskillboost-alb" {}
variable "aws_sg" {
  type = map(object({
    description = string
    port = number
    protocol = string
    cidr_blocks = list(string)
  }))
  default = {
    "22" = {
    description = "Allowed SSH"
    port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    "80" = {
    description = "Allowed HTTP"
    port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    "443" = {
    description = "Allowed HTTPs"
    port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }
}