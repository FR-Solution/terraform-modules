output "bootstrap-master-token" {
    description   = "VAULT: master tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-master
}

output "bootstrap-worker-token" {
    description   = "VAULT: worker tokens for vault access"
    value = vault_token.kubernetes-all-login-bootstrap-worker
}

output "vault_token_auth_backend_role" {
    description   = "VAULT: worker tokens for vault access"
    value = vault_token_auth_backend_role.kubernetes-all-bootstrap-worker
}

output "master_instance_list_map" {
    description   = "VAULT: worker tokens for vault access"
    value = local.master_instance_list_map
}

output "worker_instance_list_map" {
    description   = "VAULT: worker tokens for vault access"
    value = local.worker_instance_list_map
}
