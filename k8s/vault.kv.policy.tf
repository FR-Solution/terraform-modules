resource "vault_policy" "kubernetes-kv-approle" {
  for_each  = local.secret_content_map_only

  name      = format("%s-%s", each.key, var.cluster_name)

  policy = templatefile("templates/vault/vault-kv-read.tftpl", { 
    cluster_name        = var.cluster_name,
    base_vault_path_kv  = local.base_vault_path_kv
    secret_name         = each.key
    }
  )

}
