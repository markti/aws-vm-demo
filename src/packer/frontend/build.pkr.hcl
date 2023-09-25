
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

}