resource "aws_vpc" "itskillboost_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "itskillboost-vpc"
  }
}

# Public Subnet에 연결할 NACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  tags   = { Name = "public-nacl" }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

# Private 및 DB Subnet에 연결할 NACL
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  tags   = { Name = "private-nacl" }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    # cidr_block = var.vpc_cidr_block # VPC 내부망 트래픽
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    # cidr_block = var.vpc_cidr_block # VPC 내부망 트래픽
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}


# Public Subnet들을 Public NACL에 연결
resource "aws_network_acl_association" "public_assoc" {
  count = 2

  subnet_id      = aws_subnet.itskillboost-public-subnet[count.index].id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Private Subnet들을 Private NACL에 연결
resource "aws_network_acl_association" "private_assoc" {
  count = 2

  subnet_id      = aws_subnet.itskillboost-private-subnet[count.index].id
  network_acl_id = aws_network_acl.private_nacl.id
}

# DB Subnet들을 Private NACL에 연결
resource "aws_network_acl_association" "db_assoc" {
  count = 2

  subnet_id      = aws_subnet.itskillboost-db-subnet[count.index].id
  network_acl_id = aws_network_acl.private_nacl.id
}

//public subnets
resource "aws_subnet" "itskillboost-public-subnet" {
  count = 2
  vpc_id = aws_vpc.itskillboost_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = element(var.availability_zones,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "itskillboost-public-subnet-${count.index}"
  }
}

//private subnets
resource "aws_subnet" "itskillboost-private-subnet" {
  count = 2
  vpc_id = aws_vpc.itskillboost_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block,4,count.index + 2)
  availability_zone = element(var.availability_zones,count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "itskillboost-private-subnet-${count.index}"
  }
}

//db subnets
resource "aws_subnet" "itskillboost-db-subnet" {
  count = 2
  vpc_id = aws_vpc.itskillboost_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block,4,count.index + 4)
  availability_zone = element(var.availability_zones,count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "itskillboost-db-subnet-${count.index}"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  tags = { Name = "itskillboost-igw"}
}

resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "route-table-public"}
}


// eip for nat
resource "aws_eip" "nat-eip-for-db" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-for-db"
  }
}

// eip for nat
resource "aws_eip" "nat-eip-for-private" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-for-private"
  }
}

// eip for bastion
resource "aws_eip" "bastion-ip" {
  domain = "vpc"
  tags = { Name = "bastion-eip"}
  instance = var.ec2-bastion
}


// nat gateway
resource "aws_nat_gateway" "nat-db" {
  subnet_id = aws_subnet.itskillboost-public-subnet[0].id
  allocation_id = aws_eip.nat-eip-for-db.id
  tags = {
    Name = "nat-eip-for-db"
  }
}

// nat gateway
resource "aws_nat_gateway" "nat-private" {
  subnet_id = aws_subnet.itskillboost-public-subnet[1].id
  allocation_id = aws_eip.nat-eip-for-private.id
  tags = {
    Name = "nat-eip-for-private"
  }
}

resource "aws_route_table" "route-table-private" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-private.id
  }
  tags = { Name = "route-table-private"}
}


resource "aws_route_table" "route-table-db" {
  vpc_id = aws_vpc.itskillboost_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-db.id
  }
  tags = { Name = "route-table-db"}
}


resource "aws_route_table_association" "public-1" {
    subnet_id      = aws_subnet.itskillboost-public-subnet[0].id
    route_table_id = aws_route_table.route-table-public.id
}


resource "aws_route_table_association" "public-2" {
    subnet_id      = aws_subnet.itskillboost-public-subnet[1].id
    route_table_id = aws_route_table.route-table-public.id
}


resource "aws_route_table_association" "private-1" {
    subnet_id      = aws_subnet.itskillboost-private-subnet[0].id
    route_table_id = aws_route_table.route-table-private.id
}


resource "aws_route_table_association" "private-2" {
    subnet_id      = aws_subnet.itskillboost-private-subnet[1].id
    route_table_id = aws_route_table.route-table-private.id
}


resource "aws_route_table_association" "db-1" {
    subnet_id      = aws_subnet.itskillboost-db-subnet[0].id
    route_table_id = aws_route_table.route-table-db.id
}


resource "aws_route_table_association" "db-2" {
    subnet_id      = aws_subnet.itskillboost-db-subnet[1].id
    route_table_id = aws_route_table.route-table-db.id
}
