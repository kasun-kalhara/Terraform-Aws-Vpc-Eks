resource "aws_vpc" "Main-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main-vpc"
  }
}

resource "aws_internet_gateway" "internet-gateway-For-Main-Vpc" {
  vpc_id = aws_vpc.Main-vpc.id
  tags = {
    Name = "internet-gateway-For-Main-Vpc"
  }
}


resource "aws_route_table" "Route-table-for-public-subnet" {
  vpc_id = aws_vpc.Main-vpc.id
  
  tags = {
    Name = "Route-table-for-public-subnet"
  }
}


resource "aws_route_table" "Route-table-for-Private-subnet" {
  vpc_id = aws_vpc.Main-vpc.id

  tags = {
    Name = "Route-table-for-Private-subnet"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.Main-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_subnet" "Private-subnet" {
  vpc_id = aws_vpc.Main-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Private-subnet"
  }
}



resource "aws_eip" "aws_eip_for_nat_gate_way" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public-subnet.id
  allocation_id = aws_eip.nat.id

}


resource "aws_route" "route-internet-gw-to-public-route" {
  gateway_id = aws_internet_gateway.internet-gateway-For-Main-Vpc.id
  route_table_id = aws_route_table.Route-table-for-public-subnet.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "route-internet-gw-to-private-route" {
  gateway_id = aws_internet_gateway.internet-gateway-For-Main-Vpc.id
  route_table_id = aws_route_table.Route-table-for-Private-subnet.id
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "associate-public-route" {
  route_table_id = aws_route_table.Route-table-for-public-subnet.id
  subnet_id = aws_subnet.public-subnet.id
}


resource "aws_route_table_association" "associate-private-route" {
  route_table_id = aws_route_table.Route-table-for-Private-subnet.id
  subnet_id = aws_subnet.Private-subnet.id
}