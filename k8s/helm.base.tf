resource "helm_release" "base" {
  depends_on = [null_resource.cluster]
  name       = "base"
  chart      = "templates/helm/base"
  namespace  = "kube-system"
  values = [
    templatefile("templates/helm/base/values.yaml", {
        kube_apiserver_lb_access:           "${local.kube_apiserver_lb_access}"
        base64_certificate_authority_data:  "${base64encode(vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].issuing_ca)}"
        kubernetes_version:                 "${var.kubernetes-version}"
        base_local_path_certs:              "${local.base_local_path_certs}"
        service_cidr:                       "${local.service_cidr}"
        etcd_data_base_dir:                 "${var.etcd-data-base-dir}"
        kubernetes_version_major:           "${var.kubernetes-version-major}"
        kubelet_config:                     "${local.kubelet-config }"
        ssl:                                local.ssl
        kubelet-config-args:                local.kubelet-config-args
        base_path:                          var.base_path

    })
  ]
}

# output "name" {
#   value = vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].issuing_ca 
# }