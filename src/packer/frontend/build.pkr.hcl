
build {
  sources = [
    "source.azure-arm.vm",
    "source.amazon-ebs.vm",
    "source.googlecompute.vm"
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