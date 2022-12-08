output "bootstrap-issuer-worker-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-worker
}