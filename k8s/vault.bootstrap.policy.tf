resource "vault_policy" "kubernetes-all-bootstrap" {
  for_each  = local.master_instance_list_map

  name      = "clusters/${var.cluster_name}/bootstrap-all-${each.key}"

  policy = templatefile("templates/vault/vault-bootstarp-approle-all.tftpl", { 
    cluster_name          = var.cluster_name
    intermediates         = local.ssl.intermediate
    secrets               = local.secrets
    zone_name             = each.key
    }
  )
}
