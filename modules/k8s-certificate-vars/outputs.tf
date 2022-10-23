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

