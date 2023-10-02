
data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.frontend_image_name]
  }
}
/*
resource "aws_network_interface" "frontend" {
  count     = length(local.public_subnets)
  subnet_id = aws_subnet.frontend[count.index].id
}

resource "aws_instance" "frontend" {
  count = length(local.public_subnets)

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type

  network_interface {
    network_interface_id = aws_network_interface.frontend[count.index].id
    device_index         = 0
  }

}
*/