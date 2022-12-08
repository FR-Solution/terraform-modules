

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
