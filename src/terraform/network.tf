resource "aws_vpc" "main" {
  cidr_block = var.vpc_address_space
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = 1
}

locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_address_space, 6, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_address_space, 6, k + 2)]
}
