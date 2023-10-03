
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
      "declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '\"'; fi)",
      "wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb", 
      "dpkg -i packages-microsoft-prod.deb",
      "rm packages-microsoft-prod.deb", 
      "apt update"
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
      "apt-get install apt-transport-https liblttng-ust0 libcurl3 libkrb5-3 zlib1g -y",
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