resource "vault_approle_auth_backend_role" "k8s-vault-role" {

  backend                   = var.global_vars.global_path.base_vault_path_approle
  role_name                 = "kubelet-peer-k8s-certmanager"
  token_policies            = ["${var.global_vars.main_path.base_vault_path}/certificates/vault-cluster-policy"]
  token_ttl                 = 60
  secret_id_bound_cidrs     = []
  token_bound_cidrs         = []

}

resource "vault_approle_auth_backend_role_secret_id" "k8s-vault-secret" {
  backend   = var.global_vars.global_path.base_vault_path_approle
  role_name = vault_approle_auth_backend_role.k8s-vault-role.role_name
}

resource "helm_release" "base-vault-node-csr" {

  name          = "base-vault-node-csr"
  chart         = "${path.module}/helm/base-vault-node-csr"
  namespace     = "kube-system"
  atomic        = true
  values = [
    templatefile("${path.module}/helm/base-vault-node-csr/values.yaml", {
        vaut_approle_secretid : base64encode(vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)
        vaut_approle_roleid   : vault_approle_auth_backend_role.k8s-vault-role.role_id
        vaut_sign_path        : "${var.global_vars.ssl.intermediate.kubernetes-ca.path}/sign/kubelet-peer-k8s-certmanager"
        vaut_server           : var.global_vars.vault-config.vault_server
        vaut_approle_path     : var.global_vars.global_path.base_vault_path_approle
    })
  ]
}
