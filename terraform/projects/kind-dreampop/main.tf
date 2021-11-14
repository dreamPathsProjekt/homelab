terraform {
  required_version = ">= 1.0.4"
  backend "local" {}
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.1.0"
    }
  }
}

resource "null_resource" "compose_dependencies" {
  triggers = {
    compose = "v1"
  }

  provisioner "local-exec" {
    command = "docker-compose up -d"
    interpreter = ["bash", "-c"]
    working_dir = join("/", [path.root, "registry"])
  }
}

module "kind_provision" {
  source = "github.com/dreamPathsProjekt/homelab.git//terraform/modules/kind_local?ref=kind_local-v0.8.0"

  kind_config_file = join("/", [path.root, "config", "config.yaml"])

  install_prerequisites = true
  create_cluster = true
  delete_cluster = false
}
