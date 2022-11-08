resource "vault_approle_auth_backend_role" "k8s-vault-role" {
  backend         = module.k8s-vault.k8s-auth-approle-backend-path
  role_name       = "kubelet-peer-k8s-certmanager"
  token_policies  = ["${module.k8s-global-vars.global_path.base_vault_path}/certificates/kubelet-peer-k8s-certmanager"]
  token_ttl               = 60
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

resource "vault_approle_auth_backend_role_secret_id" "k8s-vault-secret" {
  backend   = module.k8s-vault.k8s-auth-approle-backend-path
  role_name = vault_approle_auth_backend_role.k8s-vault-role.role_name
}


resource "helm_release" "base" {
  depends_on = [
    helm_release.certmanager,
    helm_release.gatekeeper
    ]
  name       = "base"
  chart      = "templates/helm/base"
  namespace  = "kube-system"
  values = [
    templatefile("templates/helm/base/values.yaml", {

        vaut_approle_secretid:              base64encode(vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)
        vaut_approle_roleid:                vault_approle_auth_backend_role.k8s-vault-role.role_id
        vaut_sign_path:                     "${module.k8s-global-vars.ssl.intermediate.kubernetes-ca.path}/sign/kubelet-peer-k8s-certmanager"
        vaut_server:                        "http://193.32.219.99:9200"
        vaut_approle_path:                  module.k8s-global-vars.global_path.base_vault_path_approle

    })
  ]
}
