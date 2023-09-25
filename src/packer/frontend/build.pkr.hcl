
build {
  sources = [
    "source.amazon-ebs.vm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get clean", 
      "apt-get upgrade -y"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 6.0",
      "export PATH=\"$PATH:$HOME/.dotnet\""
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "systemctl enable myblazorapp.service"
    ]
  }

}