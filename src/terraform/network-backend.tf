

resource "aws_subnet" "backend" {

  count = length(local.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = random_shuffle.az.result[count.index]
  cidr_block        = local.private_subnets[count.index]

}
/*
resource "aws_route_table" "backend" {

  count = length(local.private_subnets)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table_association" "backend" {

  count = length(local.private_subnets)

  subnet_id      = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend[count.index].id

}

resource "aws_eip" "nat" {

  count = length(local.private_subnets)

  vpc = true
}

resource "aws_nat_gateway" "nat" {

  count = length(local.private_subnets)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.backend[count.index].id

  depends_on = [aws_internet_gateway.main]

}
*/