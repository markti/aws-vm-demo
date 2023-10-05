locals {
  private_subnets = cidrsubnets(local.public_subnets[0], 8)
}

resource "aws_subnet" "backend" {

  count = length(local.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = random_shuffle.az.result[count.index]
  cidr_block        = local.private_subnets[count.index]

}