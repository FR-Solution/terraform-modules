output "ssl" { # GLOBAL
  description   = "переменная типа object c описанием сертификатов для k8s"
  value         = local.ssl
}

output "secrets" { # GLOBAL
  description   = "переменная типа object c описанием секретов для k8s"
  value         = local.secrets
}

output "global_path" { # GLOBAL
  description   = "переменная типа string c описанием базового пути vault-kv-store"
  value         = local.global_path
}

output "main_path" { # GLOBAL
  description   = "переменная типа string c описанием базового пути vault-kv-store"
  value         = local.main_path
}


output "ssl_for_each_map" { # GLOBAL
  value         = local.ssl_for_each_map
}

output "k8s-addresses" { # GLOBAL
  value         = local.k8s-addresses
}

output "vault-config" { # GLOBAL
  value         = local.vault-config
}

output "kubernetes-ports" { # GLOBAL
  value         = local.kubernetes-ports
}

output "wildcard_base_cluster_fqdn" {
  value         = local.wildcard_base_cluster_fqdn
}

output "k8s_service_kube_apiserver_address_int" {
  value         = local.k8s_service_kube_apiserver_address_int
}

output "service-cidr" {
  value = local.base.service_cidr
}

output "ssh_username" {
  value =local.base.ssh_username
}

output "ssh_rsa_path" {
  value = local.base.ssh_rsa_path
}

output "extra_cluster_name" {
  value = local.extra_cluster_name
}

output "kube_apiserver_lb_fqdn" {
  value         = local.kube_apiserver_lb_fqdn
}

output "kube_apiserver_lb_fqdn_local" {
  value         = local.kube_apiserver_lb_fqdn_local
}


output "base_domain" {
  value         = local.base.base_domain
}

output "cluster_name" {
  value = local.base.cluster_name
}

output "base_cluster_fqdn" {
  value         = local.base_cluster_fqdn
}

output "base" {
  value = local.base
}
