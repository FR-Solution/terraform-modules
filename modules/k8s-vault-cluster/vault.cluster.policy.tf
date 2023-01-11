resource "vault_policy" "kubernetes-bootstrap-master" {

  name      = "${var.k8s_global_vars.global_path.base_vault_path}/certificates/vault-cluster-policy"

  policy = templatefile("${path.module}/templates/vault/vault-cluster-policies.tftpl", { 
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle
    intermediat_path        = var.k8s_global_vars.ssl.intermediate.kubernetes-ca.path
    issuer_name             = "kubelet-peer-k8s-certmanager"
    }
  )
}
