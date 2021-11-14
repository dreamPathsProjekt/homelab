terraform {
  required_version = ">= 1.0.4"
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

data "local_file" "kind_config" {
  filename = var.kind_config_file
}

locals {
  kubeversion = {
    "1.22" = "kindest/node:v1.22.0@sha256:b8bda84bb3a190e6e028b1760d277454a72267a5454b57db34437c34a588d047"
    "1.21" = "kindest/node:v1.21.1@sha256:69860bda5563ac81e3c0057d654b5253219618a22ec3a346306239bba8cfa1a6"
    "1.20" = "kindest/node:v1.20.7@sha256:cbeaf907fc78ac97ce7b625e4bf0de16e3ea725daf6b04f930bd14c67c671ff9"
    "1.19" = "kindest/node:v1.19.11@sha256:07db187ae84b4b7de440a73886f008cf903fcf5764ba8106a9fd5243d6f32729"
    "1.18" = "kindest/node:v1.18.19@sha256:7af1492e19b3192a79f606e43c35fb741e520d195f96399284515f077b3b622c"
    "1.17" = "kindest/node:v1.17.17@sha256:66f1d0d91a88b8a001811e2f1054af60eef3b669a9a74f9b6db871f2f1eeed00"
    "1.16" = "kindest/node:v1.16.15@sha256:83067ed51bf2a3395b24687094e283a7c7c865ccc12a8b1d7aa673ba0c5e8861"
    "1.15" = "kindest/node:v1.15.12@sha256:b920920e1eda689d9936dfcf7332701e80be12566999152626b2c9d730397a95"
    "1.14" = "kindest/node:v1.14.10@sha256:f8a66ef82822ab4f7569e91a5bccaf27bceee135c1457c512e54de8c6f7219f8"
  }
  cluster_name = yamldecode(data.local_file.kind_config.content).name
  install_script = join("/", [path.module, "scripts", "install.sh"])
  cluster_script = join("/", [path.module, "scripts", "cluster.sh"])
}

resource "null_resource" "install_docker" {
  count = var.install_prerequisites ? 1 : 0
  triggers = {
    docker = var.install_prerequisites
  }

  provisioner "local-exec" {
    command = "chmod +x ${local.install_script} && sudo ${local.install_script} install docker"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "install_kind" {
  count = var.install_prerequisites ? 1 : 0
  triggers = {
    kind = var.install_prerequisites
  }

  provisioner "local-exec" {
    command = "sudo ${local.install_script} install kind"
    interpreter = ["bash", "-c"]
    environment = {
      KIND_VERSION = var.kind_version
    }
  }

  depends_on = [null_resource.install_docker]
}

resource "null_resource" "create_cluster" {
  count = var.create_cluster || var.delete_cluster ? 1 : 0
  triggers = {
    create = var.create_cluster
    delete = var.delete_cluster
  }

  provisioner "local-exec" {
    command = "chmod +x ${local.cluster_script}"
  }

  provisioner "local-exec" {
    command = var.delete_cluster ? "${local.cluster_script} delete ${local.cluster_name}" : "${local.cluster_script} create ${local.cluster_name} ${data.local_file.kind_config.filename}"
    interpreter = ["bash", "-c"]
  }

  depends_on = [null_resource.install_kind]
}
