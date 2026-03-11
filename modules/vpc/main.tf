data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.environment}-vpc"
  }

}

resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-a"
  }

}

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-b"
  }

}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }

}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }

}

resource "aws_route_table_association" "subnet_a" {

  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "subnet_b" {

  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
 
}