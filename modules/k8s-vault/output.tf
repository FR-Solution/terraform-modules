output "bootstrap-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-master
}

output "bootstrap-worker-token" {
    description   = "VAULT: worker tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-worker
}