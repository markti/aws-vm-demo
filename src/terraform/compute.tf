
data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.frontend_image_name]
  }
}

data "aws_key_pair" "temp" {
  key_name = "temp_key"
}

resource "aws_key_pair" "frontend" {
  key_name   = "frontend-key"
  public_key = trimspace(var.ssh_public_key)
}

resource "aws_network_interface" "frontend" {

  for_each = aws_subnet.frontend

  subnet_id = each.value.id
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {

  for_each = aws_instance.frontend

  security_group_id    = aws_security_group.frontend.id
  network_interface_id = each.value.primary_network_interface_id

}

resource "aws_instance" "frontend" {

  for_each = aws_subnet.frontend

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type
  key_name      = data.aws_key_pair.temp.key_name

  network_interface {
    network_interface_id = aws_network_interface.frontend[each.key].id
    device_index         = 0
  }

}

resource "aws_eip" "nat" {

  for_each = aws_instance.frontend

  instance = each.value.id

}