
output "bootstrap-worker-token" {
    description   = "VAULT: worker tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-worker
}

output "k8s-cluster-admin-certs" {
    value = vault_pki_secret_backend_cert.terraform-kubeconfig
}


output "k8s-auth-approle-backend-path" {
    value = vault_auth_backend.approle.path
}


output "bootstrap-issuer-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-dedicated-issuer-login-bootstrap-master
}

output "bootstrap-ca-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-dedicated-ca-login-bootstrap-master
}

output "bootstrap-external-ca-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-dedicated-external-ca-login-bootstrap-master
}

output "bootstrap-secret-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-dedicated-secret-login-bootstrap-master
}

