## output
output "itskillboost_vpc_id" {
  value = aws_vpc.itskillboost_vpc.id
  sensitive = false
}

output "itskillboost-private-subnet-0" {
  value = aws_subnet.itskillboost-private-subnet[0].id
}
output "itskillboost-private-subnet-1" {
  value = aws_subnet.itskillboost-private-subnet[1].id
}
output "itskillboost-public-subnet-0" {
  value = aws_subnet.itskillboost-public-subnet[0].id
}
output "itskillboost-public-subnet-1" {
  value = aws_subnet.itskillboost-public-subnet[1].id
}