module "k8s-cloud-init" {
    source                       = "../k8s-templates/cloud-init"
    k8s_global_vars              = var.k8s_global_vars

    vault-bootstrap-issuer-master-token         = vault_token.kubernetes-dedicated-issuer-login-bootstrap-master
    vault-bootstrap-ca-master-token             = vault_token.kubernetes-dedicated-ca-login-bootstrap-master
    vault-bootstrap-external-ca-master-token    = vault_token.kubernetes-dedicated-external-ca-login-bootstrap-master
    vault-bootstrap-secret-master-token         = vault_token.kubernetes-dedicated-secret-login-bootstrap-master
}

