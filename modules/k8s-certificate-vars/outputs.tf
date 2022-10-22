output "ssl" {
  description   = "переменная типа object c описанием сертификатов"
  value         = local.ssl
}

output "secrets" {
  description   = "переменная типа object c описанием сертификатов"
  value         = local.secrets
}

output "base_vault_path_kv" {
  description   = "переменная типа object c описанием сертификатов"
  value         = local.base_vault_path_kv
}

output "base_vault_path_approle" {
  description   = "переменная типа object c описанием сертификатов"
  value         = local.base_vault_path_approle
}

