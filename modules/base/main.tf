resource "aws_vpc" "vpc_main" {
 cidr_block = "10.12.0.0/16"

 tags = {
   Name = "MongoVPC"
 }
}

resource "aws_subnet" "subnet_public" {
  count = length(var.cidr_subnet_public)
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = element(var.cidr_subnet_public, count.index)

  tags = {
    Name = "Public Subnet ${count.index +1}"
  }
}

resource "aws_subnet" "subnet_private" {
  count = length(var.cidr_subnet_private)
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = element(var.cidr_subnet_private, count.index)

  tags = {
    Name = "Private Subnet ${count.index +1}"
  }
}
