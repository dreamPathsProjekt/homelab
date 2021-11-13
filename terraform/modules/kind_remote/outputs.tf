output "kind_config" {
  value = data.local_file.kind_config
}

output "kind_node_versions" {
  value = local.kubeversion
}

output "kind_cluster_name" {
  value = local.cluster_name
}
