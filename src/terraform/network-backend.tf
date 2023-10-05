locals {
  private_subnets = cidrsubnets("10.0.2.0/24", 4)
}

resource "aws_subnet" "backend" {

  count = length(local.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = random_shuffle.az.result[count.index]
  cidr_block        = local.private_subnets[count.index]

}

resource "aws_route_table" "backend" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {

  count = length(local.private_subnets)

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.backend[count.index].id

  depends_on = [aws_internet_gateway.main]

}