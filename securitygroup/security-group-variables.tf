variable "itskillboost_vpc_id" {}
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

variable "alb_sg" {
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

variable "bastion_sg" {
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
  }
}