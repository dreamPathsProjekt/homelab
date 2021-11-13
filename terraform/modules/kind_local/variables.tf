variable "install_prerequisites" {
  default = true
}

variable "create_cluster" {
  default = true
}

variable "delete_cluster" {
  default = false
}

variable "kind_config_file" {
  default = "config.yaml"
}
