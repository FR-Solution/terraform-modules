resource "vault_policy" "kubernetes-kv" {
  for_each  = local.secret_content_map_only

  name      = format("%s-%s", each.key, var.cluster_name)

  policy = templatefile("templates/vault/vault-kv-read.tftpl", { 
    cluster_name        = var.cluster_name,
    base_vault_path_kv  = local.base_vault_path_kv
    secret_name         = each.key
    }
  )

}

resource "vault_policy" "kubernetes-kv-bootstrap" {
  for_each  = local.secret_content_map_only

  name      = "clusters/${var.cluster_name}/ca/bootstrap-${each.key}"

  policy = templatefile("templates/vault/vault-kv-bootstrap-role.tftpl", { 
    cluster_name          = var.cluster_name,
    approle_name          = each.key
    master_instance_list  = local.master_instance_list
    }
  )
}

