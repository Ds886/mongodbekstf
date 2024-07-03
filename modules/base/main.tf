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
    Name    = "Public Subnet ${count.index + 1}"
    Project = "MonogoVPC"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = length(var.cidr_subnet_private)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = element(var.cidr_subnet_private, count.index)
  availability_zone = element(var.subnet_az_list, count.index)

  tags = {
    Name    = "Private Subnet ${count.index + 1}"
    Project = "MonogoVPC"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name    = "Mongo Internet Gateway"
    Project = "MonogoVPC"
  }
}
