resource "vault_policy" "kubernetes-kv-approle" {
  for_each  = var.k8s_global_vars.ssl_for_each_map.secret_content_map_only

  name      = "${var.k8s_global_vars.global_path.base_vault_path_kv}/${each.key}"

  policy = templatefile("${path.module}/templates/vault/vault-kv-read.tftpl", { 
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle,
    base_vault_path_kv  = var.k8s_global_vars.global_path.base_vault_path_kv
    secret_name         = each.key
    }
  )
}
