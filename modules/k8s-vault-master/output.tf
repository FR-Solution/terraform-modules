output "secret_id_all" {
  value = vault_approle_auth_backend_role_secret_id.all_masters
}
output "role_id_all" {
  value = vault_approle_auth_backend_role.all_masters
}