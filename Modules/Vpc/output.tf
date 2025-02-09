output "Main-vpc-id" {
  value = aws_vpc.Main-vpc.id
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet.id
}

output "private-subnet-id" {
  value = aws_subnet.Private-subnet.id
}