
build {
  sources = [
    "source.amazon-ebs.vm"
  ]

  provisioner "file" {
    source = "./files/dotnet.pref"
    destination = "/tmp/dotnet.pref"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/dotnet.pref /etc/apt/preferences.d/dotnet.pref"
    ]
  }

  # install dotnet
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get clean", 
      "apt-get upgrade -y",
      "apt-get install unzip -y", 
      "apt-get install apt-transport-https liblttng-ust0 libcurl3 libkrb5-3 zlib1g -y"
      "apt-get install dotnet-sdk-6.0 -y"
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