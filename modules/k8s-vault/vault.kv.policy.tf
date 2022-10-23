resource "vault_policy" "kubernetes-kv-approle" {
  for_each  = local.secret_content_map_only

  name      = "clusters/${var.cluster_name}/kv/${each.key}"

  policy = templatefile("../../modules/k8s-vault/templates/vault/vault-kv-read.tftpl", { 
    cluster_name        = var.cluster_name,
    base_vault_path_kv  = var.k8s_certificate_vars.base_vault_path_kv
    secret_name         = each.key
    }
  )
}
