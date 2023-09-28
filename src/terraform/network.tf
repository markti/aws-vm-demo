resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8)
}

resource "aws_subnet" "frontend" {

  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = local.public_subnets[count.index]
}
