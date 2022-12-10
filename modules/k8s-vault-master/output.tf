

# output "bootstrap-issuer-master-token" {
#     description   = "VAULT: master tokens for vault access"
#     value = vault_token.kubernetes-dedicated-issuer-login-bootstrap-master
# }

# output "bootstrap-ca-master-token" {
#     description   = "VAULT: master tokens for vault access"
#     value = vault_token.kubernetes-dedicated-ca-login-bootstrap-master
# }

# output "bootstrap-external-ca-master-token" {
#     description   = "VAULT: master tokens for vault access"
#     value = vault_token.kubernetes-dedicated-external-ca-login-bootstrap-master
# }

# output "bootstrap-secret-master-token" {
#     description   = "VAULT: master tokens for vault access"
#     value = vault_token.kubernetes-dedicated-secret-login-bootstrap-master
# }

output "bootstrap-all" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-master
}


output "secret_id_cert" {
  value = vault_approle_auth_backend_role_secret_id.kubernetes-sign-master
}
output "role_id_cert" {
  value = vault_approle_auth_backend_role.kubernetes-sign-master
}

output "secret_id_ca" {
  value = vault_approle_auth_backend_role_secret_id.kubernetes-ca-master
}
output "role_id_ca" {
  value = vault_approle_auth_backend_role.kubernetes-ca-master
}

output "secret_id_external_ca" {
  value = vault_approle_auth_backend_role_secret_id.external-ca-master
}
output "role_id_external_ca" {
  value = vault_approle_auth_backend_role.external-ca-master
}

output "secret_id_kv" {
  value = vault_approle_auth_backend_role_secret_id.kubernetes-kv
}
output "role_id_kv" {
  value = vault_approle_auth_backend_role.kubernetes-kv
}