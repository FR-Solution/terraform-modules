output "bootstrap-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-master
}

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
