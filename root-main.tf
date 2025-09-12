module "network" {
  source = "./network"
  ec2-bastion = module.instance.ec2-bastion
}

module "instance" {
  source = "./instance"
  allow_web = module.securitygroup.allow_web
  bastion = module.securitygroup.bastion
  mykey_key_name = module.keys.mykey_key_name
  itskillboost-private-subnet-0 = module.network.itskillboost-private-subnet-0
  itskillboost-private-subnet-1 = module.network.itskillboost-private-subnet-1
  itskillboost-public-subnet-0 = module.network.itskillboost-public-subnet-0
  itskillboost-public-subnet-1 = module.network.itskillboost-public-subnet-1
}

module "securitygroup" {
  source = "./securitygroup"
  itskillboost_vpc_id = module.network.itskillboost_vpc_id
}

module "loadbalancer" {
  source = "./loadbalancer"
  itskillboost_vpc_id = module.network.itskillboost_vpc_id
  # ec2-web01 = module.instance.ec2-web01
  # ec2-web02 = module.instance.ec2-web02
  itskillboost-public-subnet-0 = module.network.itskillboost-public-subnet-0
  itskillboost-public-subnet-1 = module.network.itskillboost-public-subnet-1
  allow_alb = module.securitygroup.allow_alb
}

module "autoscalinggroup" {
  source = "./autoscalinggroup"
  allow_alb = module.securitygroup.allow_alb
  itskillboost-private-subnet-0 = module.network.itskillboost-private-subnet-0
  itskillboost-private-subnet-1 = module.network.itskillboost-private-subnet-1
  itskillboost_vpc_id = module.network.itskillboost_vpc_id
  mykey_key_name = module.keys.mykey_key_name
  ami-instance = module.instance.ami-instance
  itskillboost-tg = module.loadbalancer.itskillboost-tg
  aws_route53_zone = module.route53.aws_route53_zone
  itskillboost-alb = module.loadbalancer.itskillboost-alb
}

module "route53" {
  source = "./route53"
}

module "cloudfront" {
  source = "./cloudfront"
}

module "cloudwatch" {
  source = "./cloudwatch"
}

module "keys" {
  source = "./keys"
}

module "sns" {
  source = "./sns"
}

module "sqs" {
  source = "./sqs"
}