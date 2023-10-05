locals {
  public_subnets = cidrsubnets("10.0.1.0/24", 4)
}

resource "aws_subnet" "frontend" {

  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = random_shuffle.az.result[count.index]
  cidr_block        = local.public_subnets[count.index]

}

# must allow IGW access to the internet
resource "aws_route_table" "frontend" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "frontend" {

  count = length(local.public_subnets)

  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend.id

}