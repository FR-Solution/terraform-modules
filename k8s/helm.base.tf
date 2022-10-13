resource "vault_approle_auth_backend_role" "k8s-vault-role" {
  backend         = vault_auth_backend.approle.path
  role_name       = "kubelet-peer-k8s-certmanager"
  token_policies  = ["${local.base_vault_path}/certificates/kubelet-peer-k8s-certmanager"]
  token_ttl               = 60
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

resource "vault_approle_auth_backend_role_secret_id" "k8s-vault-secret" {
  backend   = vault_auth_backend.approle.path
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

        base64_certificate_authority_data:  base64encode(vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].issuing_ca)
        vaut_approle_secretid:              base64encode(vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)
        kube_apiserver_lb_access:           local.kube_apiserver_lb_access
        base_local_path_certs:              local.base_local_path_certs
        service_cidr:                       local.service_cidr
        # kubelet_config:                     local.kubelet-config 
        ssl:                                local.ssl
        kubelet-config-args:                local.kubelet-config-args
        etcd_data_base_dir:                 var.etcd-data-base-dir
        kubernetes_version_major:           var.kubernetes-version-major
        kubernetes_version:                 var.kubernetes-version
        base_path:                          var.base_path
        vaut_approle_roleid:                vault_approle_auth_backend_role.k8s-vault-role.role_id
        vaut_sign_path:                     "${local.ssl.intermediate.kubernetes-ca.path}/sign/kubelet-peer-k8s-certmanager"
        vaut_server:                        "http://193.32.219.99:9200"
        vaut_approle_path:                  local.base_vault_path_approle
        yandex_cloud_controller_sa:         local.yandex-cloud-controller-sa
    })
  ]
}
