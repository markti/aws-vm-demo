resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = 2
}

locals {
  azs             = random_shuffle.az.result
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 2)]
}
