resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = 1
}

locals {
  public_subnets = cidrsubnets("10.0.0.0/16", 8)
}

resource "aws_subnet" "frontend" {

  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = random_shuffle.az.result[count.index]
  cidr_block        = local.public_subnets[count.index]
}


resource "aws_route_table_association" "frontend" {

  count          = length(local.public_subnets)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.main.id
}