locals {
    global_path = {
        base_kubernetes_path    = var.base_kubernetes_path    == null ? "/etc/kubernetes"                       : var.base_kubernetes_path
        base_local_path_certs   = var.base_local_path_certs   == null ? "/etc/kubernetes/pki"                   : var.base_local_path_certs
        base_static_pod_path    = var.base_static_pod_path    == null ? "/etc/kubernetes/manifests"             : var.base_static_pod_path
        base_local_path_vault   = var.base_local_path_vault   == null ? "/var/lib/key-keeper/vault"             : var.base_local_path_vault
        base_vault_path         = var.base_vault_path         == null ? "clusters/${var.cluster_name}"          : var.base_vault_path
        base_vault_path_kv      = var.base_vault_path_kv      == null ? "clusters/${var.cluster_name}/kv"       : var.base_vault_path_kv
        base_vault_path_approle = var.base_vault_path_approle == null ? "clusters/${var.cluster_name}/approle"  : var.base_vault_path_approle
        root_vault_path_pki     = var.root_vault_path_pki     == null ? "pki-root"                              : var.root_vault_path_pki
    }

}
