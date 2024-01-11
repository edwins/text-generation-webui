module "app_proxy" {
    # source = "git::https://gitlab.com/cyverse/cacao-tf-os-ops.git//single-image-app-proxy?ref=2023-12-13"
    source = "git::https://gitlab.com/cyverse/cacao-tf-os-ops.git//single-image-app-proxy?ref=js2"

    # this is an example of hardcoding the distro because you don't want people to change it
    image_name = "Featured-Ubuntu22"
    proxy_auth_type = "basicauth"
    proxy_target_port = 7860
    # proxy_auth_user = "appuser"

    # add this to your inputs.tf
    username = var.username
    region = var.region
    project = var.project
    instance_name = var.instance_name
    instance_count = var.instance_count
    flavor = var.flavor
    keypair = var.keypair
    power_state = var.power_state
    user_data = var.user_data
    proxy_auth_user = local.proxy_auth_user
    proxy_auth_pass = var.proxy_auth_pass # leaving this blank will generate a random password
    proxy_expose_logfiles = "/var/log/text-generation-webui.log"
}

resource "null_resource" "text_generation_webui" {
  # count = length(module.app_proxy.instance_ips)

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_PIPELINING=True ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i ${module.app_proxy.ansible_inventory_path} --forks=10 playbook.yaml"
    working_dir = "${path.module}/ansible"
  }

  depends_on = [
    module.app_proxy.ansible-execution
  ]
}

resource "local_file" "tgwui_config" {
    content = templatefile("${path.module}/config.yaml.tmpl",
    {
      cacao_user = var.username
      tgwui_version = var.tgwui_version
      tgwui_cli_flags = "${var.tgwui_cli_flags} ${local.tgwui_cli_flag_cpu}"
      tgwui_gpu_enabled = startswith(var.flavor, "g3")
    })
    filename = "${path.module}/ansible/config.yaml"
}

locals {
  # this is js2 only? need to confirm with regional clouds
  tgwui_cli_flag_cpu = startswith(var.flavor, "g3") ? "" : "--cpu"
  proxy_auth_user = var.proxy_auth_user != "" ? var.proxy_auth_user : var.username
}


output "ansible_inventory_path" {
  description = "path to the ansible inventory file"
  value = module.app_proxy.ansible_inventory_path
}
output "instance_ips" {
  description = "IP addresses for all instances"
  value = module.app_proxy.instance_ips
}

output "instance_public_endpoints" {
  description = "Public endpoints for all instances"
  value = module.app_proxy.instance_public_endpoints
}

