output "secret_id_all" {
  description = "the secret_id list was generated from the masters"
  value = vault_approle_auth_backend_role_secret_id.all_masters
}

output "role_id_all" {
  description = "the role_id list was generated from the masters"
  value = vault_approle_auth_backend_role.all_masters
}
