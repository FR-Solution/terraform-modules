resource "vault_pki_secret_backend_cert" "terraform-kubeconfig" {
    depends_on = [
      vault_pki_secret_backend_role.kubernetes-role,
      vault_mount.intermediate

    ]
    backend       = var.k8s_global_vars.ssl.intermediate.kubernetes-ca.path
    name          = "kube-apiserver-cluster-admin-client"
    common_name   = "custom:terraform-kubeconfig"
}
