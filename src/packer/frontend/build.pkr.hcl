
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

  # install dotnet pre-reqs
  provisioner "shell" {
    execute_command = local.execute_command
    script = "./scripts/install-dotnet6-prereq.sh"
  }

  # install dotnet6
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get install dotnet-sdk-6.0 -y"
    ]
  }

  # setup svc user
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "groupadd myblazorapp-svc",
      "adduser -g myblazorapp-svc myblazorapp-svc",
      "chown -R myblazorapp-svc:myblazorapp-svc /var/www/myblazorapp"
    ]
  }

  # grant user access to dotnet dir
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "chown -R myblazorapp-svc:myblazorapp-svc /var/www/.dotnet",
      "chmod -R 755 /var/www/.dotnet"
    ]
  }

  # apt-install
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get install unzip -y"
    ]
  }

  provisioner "file" {
    source = "./deployment.zip"
    destination = "/tmp/deployment.zip"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p /var/www/myblazorapp",
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