provider "local" {}

resource "local_file" "nomad_config" {
  content = <<-EOT
  bind_addr = "0.0.0.0"

  server {
    enabled = true
    bootstrap_expect = 1
  }

  client {
    enabled = true
  }

  data_dir = "C:/Program Files/Nomad"
  EOT
  filename = "${path.module}/nomad.hcl"
}

resource "null_resource" "install_nomad" {
  provisioner "local-exec" {
    command = <<-EOT
    mkdir -p "/c/Program Files/Nomad"
    mv ./nomad.hcl "/c/Program Files/Nomad/nomad.hcl"
    nohup "/c/Program Files/Nomad/nomad.exe" agent -config "/c/Program Files/Nomad/nomad.hcl" &
    EOT
    interpreter = ["bash", "-c"]
  }
}

output "nomad_config" {
  value = local_file.nomad_config.content
}
