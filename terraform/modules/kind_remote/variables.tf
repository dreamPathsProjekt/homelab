variable "create_cluster" {
  default = true
}
variable "delete_cluster" {
  default = false
}

variable "instance" {
  type = map(object({
    host = string
    username = string
    ssh_private_key = string
  }))
}

variable "kind_config_file" {
  default = "config.yaml"
}
