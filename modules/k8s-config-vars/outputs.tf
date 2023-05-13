output "ssl" {
  value         = local.ssl
}

output "secrets" {
  value         = local.secrets
}

output "global_path" {
  value         = local.global_path
}

output "main_path" {
  value         = local.main_path
}

output "ssl_for_each_map" {
  value         = local.ssl_for_each_map
}

output "k8s-addresses" {
  value         = local.k8s-addresses
}

output "vault-config" {
  value         = local.vault-config
}

output "kubernetes-ports" {
  value         = local.kubernetes-ports
}

output "base" {
  value = local.base
}

output "k8s_network" {
  value = local.k8s_network
}

output "cluster_metadata" {
  value = local.cluster_metadata
}

output "kube_flags" {
  value = local.kube_flags
}

output "k8s_provider" {
  value = local.k8s_provider
}

output "master_vars" {
  value = local.master_vars
}