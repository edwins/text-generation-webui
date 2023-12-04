module "app_proxy" {
    source = "git::https://gitlab.com/cyverse/cacao-tf-os-ops.git//single-image-app-proxy?ref=2023-12-03"

    # this is an example of hardcoding the distro because you don't want people to change it
    image_name = "Featured-Ubuntu22"
    proxy_auth_type = "basicauth"
    proxy_target_port = 7860
    proxy_auth_user = "myappuser"

    # add this to your inputs.tf
    username = var.username
    region = var.region
    project = var.project
    instance_name = var.instance_name
    instance_count = var.instance_count
    flavor = var.flavor
    keypair = var.keypair
    proxy_auth_pass = var.proxy_auth_pass # leaving this blank will generate a random password
}

resource "null_resource" "provision" {
  count = length(module.app_proxy.instance_ips)

  connection {
    type = "ssh"
    agent = true
    user = var.username
    host = module.app_proxy.instance_ips[count.index]
  }

  provisioner "remote-exec" {
    inline = [<<-EOF
      #!/bin/bash

      cd /home/${var.username}

      git clone https://github.com/oobabooga/text-generation-webui.git

      cd text-generation-webui

      export GPU_CHOICE=A
      export USE_CUDA118=N

      chmod a+x start_linux.sh

      nohup ./start_linux.sh >../text-generation-webui.log 2>&1 &

      sleep 1

      EOF
    ]
  }
}



output "instance_ips" {
  description = "IP addresses for all instances"
  value = module.app_proxy.instance_ips
}

output "instance_public_endpoints" {
  description = "Public endpoints for all instances"
  value = module.app_proxy.instance_public_endpoints
}