output "ssl" {
  description   = "переменная типа object c описанием сертификатов для k8s"
  value         = local.ssl
}

output "secrets" {
  description   = "переменная типа object c описанием секретов для k8s"
  value         = local.secrets
}

output "global_path" {
  description   = "переменная типа string c описанием базового пути vault-kv-store"
  value         = local.global_path
}

output "kube_apiserver_lb_fqdn" {
  value         = local.kube_apiserver_lb_fqdn
}

output "kube_apiserver_lb_fqdn_local" {
  value         = local.kube_apiserver_lb_fqdn_local
}

output "wildcard_base_cluster_fqdn" {
  value         = local.wildcard_base_cluster_fqdn
}

output "k8s_service_kube_apiserver_address_int" {
  value         = local.k8s_service_kube_apiserver_address_int
}

output "ssl_for_each_map" {
  value         = local.ssl_for_each_map
}

output "master_instance_list" {
  value         = local.master_instance_list
}

output "worker_instance_list" {
  value         = local.worker_instance_list
}

output "base_domain" {
  value         = var.base_domain
}

output "base_cluster_fqdn" {
  value         = local.base_cluster_fqdn
}

output "k8s-addresses" {
  value         = local.k8s-addresses
}

output "vault-config" {
  value         = local.vault-config
}
