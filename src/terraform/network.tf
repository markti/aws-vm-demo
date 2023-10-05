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
  # subnet maps
  azs_random = random_shuffle.az.result
  azs_slice  = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets = { for k, v in local.azs_random :
    k => {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, k)
      az_name    = v
    }
  }
  private_subnets = { for k, v in local.azs_random :
    k => {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, k + 2)
      az_name    = v
    }
  }
}
