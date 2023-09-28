
build {
  sources = [
    "source.amazon-ebs.vm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get clean", 
      "apt-get upgrade -y",
      "apt-get install unzip -y"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 6.0",
      "export PATH=\"$PATH:$HOME/.dotnet\""
    ]
  }

  provisioner "file" {
    source = "./deployment.zip"
    destination = "/tmp/deployment.zip"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "unzip /tmp/deployment.zip -d /var/www/myblazorapp"
    ]
  }

  provisioner "file" {
    source = "./files/myblazorapp.service"
    destination = "/tmp/myblazorapp.service"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/myblazorapp.service /etc/systemd/system/myblazorapp.service"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "systemctl enable myblazorapp.service"
    ]
  }

}