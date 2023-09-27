resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8)
}

output "public_subnets" {
  value = local.public_subnets
}

resource "aws_subnet" "frontend" {

  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = local.public_subnets[count.index]
}

data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.frontend_image_name]
  }
}
