
data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.frontend_image_name]
  }
}

resource "tls_private_key" "frontend" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "frontend" {
  key_name   = "frontend-key"
  public_key = tls_private_key.frontend.public_key_openssh
}


resource "aws_network_interface" "frontend" {
  count     = length(local.public_subnets)
  subnet_id = aws_subnet.frontend[count.index].id
}

resource "aws_instance" "frontend" {
  count = length(local.public_subnets)

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.frontend[count.index].id
    device_index         = 0
  }

}
resource "aws_eip" "frontend" {
  count    = length(local.public_subnets)
  instance = aws_instance.frontend[count.index].id
}