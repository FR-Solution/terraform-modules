output "ssl" {
  description   = "переменная типа object c описанием сертификатов для k8s"
  value         = local.ssl
}

output "secrets" {
  description   = "переменная типа object c описанием секретов для k8s"
  value         = local.secrets
}

output "base_vault_path_kv" {
  description   = "переменная типа string c описанием базового пути vault-kv-store"
  value         = local.base_vault_path_kv
}

output "base_vault_path_approle" {
  description   = "переменная типа string c описанием базового пути approles"
  value         = local.base_vault_path_approle
}


output "base_local_path_certs" {
  value         = local.base_local_path_certs
}

output "base_local_path_vault" {
  value         = local.base_local_path_vault
}

output "base_vault_path" {
  value         = local.base_vault_path
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
