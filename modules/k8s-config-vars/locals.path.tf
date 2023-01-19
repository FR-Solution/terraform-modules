locals {
    main_path = {
        base_vault_path         = try(var.extra_args.base_vault_path, null)        == null ? "clusters/${local.cluster_metadata.cluster_name}"  : var.extra_args.base_vault_path
        base_kubernetes_path    = try(var.extra_args.base_kubernetes_path, null)   == null ? "/etc/kubernetes"                      : var.extra_args.base_kubernetes_path
    }

    global_path = {
        base_local_path_certs   = try(var.extra_args.base_local_path_certs, null)   == null ? "${local.main_path.base_kubernetes_path}/pki"         : var.extra_args.base_local_path_certs
        base_static_pod_path    = try(var.extra_args.base_static_pod_path, null)    == null ? "${local.main_path.base_kubernetes_path}/manifests"   : var.extra_args.base_static_pod_path
        base_local_path_vault   = try(var.extra_args.base_local_path_vault, null)   == null ? "/var/lib/key-keeper/vault"                           : var.extra_args.base_local_path_vault
        base_vault_path_pki     = try(var.extra_args.base_vault_path, null)         == null ? "${local.main_path.base_vault_path}/pki"              : var.extra_args.base_vault_path
        base_vault_path_kv      = try(var.extra_args.base_vault_path_kv, null)      == null ? "${local.main_path.base_vault_path}/kv"               : var.extra_args.base_vault_path_kv
        base_vault_path_approle = try(var.extra_args.base_vault_path_approle, null) == null ? "${local.main_path.base_vault_path}/approle"          : var.extra_args.base_vault_path_approle
        root_vault_path_pki     = try(var.extra_args.root_vault_path_pki, null)     == null ? "pki-root"                                            : var.extra_args.root_vault_path_pki 
    }
}
