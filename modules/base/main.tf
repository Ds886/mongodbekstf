resource "aws_vpc" "vpc_main" {
  cidr_block = "10.12.0.0/16"

  tags = {
    Name = "MongoVPC"
  }
}

resource "aws_subnet" "subnet_public" {
  count             = length(var.cidr_subnet_public)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = element(var.cidr_subnet_public, count.index)
  availability_zone = element(var.subnet_az_list, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = length(var.cidr_subnet_private)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = element(var.cidr_subnet_private, count.index)
  availability_zone = element(var.subnet_az_list, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "Mongo Internet Gateway"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "public_asso" {
  count          = length(var.cidr_subnet_public)
  subnet_id      = element(aws_subnet.subnet_public[*].id, count.index)
  route_table_id = aws_route_table.rt_public.id
}
