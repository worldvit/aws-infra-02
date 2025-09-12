module "network" {
  source = "./network"
  ec2-bastion = module.instance.ec2-bastion
}

module "instance" {
  source = "./instance"
  allowd_web = module.securitygroup.allowd_web
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

module "autoscalinggroup" {
  source = "./autoscalinggroup"
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