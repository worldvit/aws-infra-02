variable "AWS_REGION" { default = "us-west-2" }
variable "ins_type" { default = "t3.micro" }

# https://cloud-images.ubuntu.com/locator/ec2/
variable "AMIS" {
    type = map(string)
    default = {
      "us-east-1" = "ami-0360c520857e3138f"
      "us-east-2" = "ami-0cfde0ea8edd312d4"
      "us-west-1" = "ami-00271c85bf8a52b84"
      "us-west-2" = "ami-03aa99ddf5498ceb9"
    }
}
variable "PATH_TO_PUBLIC_KEY" { default = "keys/mykey.pub" }
variable "PATH_TO_PRIVATE_KEY" { default = "keys/mykey" }
variable "INSTANCE_USERNAME" { default = "ubuntu" }
variable "availability_zones" {
  type = list(string)
  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
    "us-west-2d"
  ]
}