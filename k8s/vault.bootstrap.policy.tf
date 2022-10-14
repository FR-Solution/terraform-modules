resource "vault_policy" "kubernetes-all-bootstrap-master" {
  for_each  = local.master_instance_list_map

  name      = "clusters/${var.cluster_name}/bootstrap-all-${each.key}"

  policy = templatefile("templates/vault/vault-bootstarp-approle-all.tftpl", { 
    cluster_name            = var.cluster_name
    intermediates           = local.ssl.intermediate
    external_intermediates  = local.ssl.external_intermediate
    secrets                 = local.secrets
    zone_name               = each.key
    instance_type           = "master"
    }
  )
}

resource "vault_policy" "kubernetes-all-bootstrap-worker" {
  for_each  = local.worker_instance_list_map

  name      = "clusters/${var.cluster_name}/bootstrap-all-${each.key}"

  policy = templatefile("templates/vault/vault-bootstarp-approle-all.tftpl", { 
    cluster_name            = var.cluster_name
    intermediates           = local.ssl.intermediate
    external_intermediates  = local.ssl.external_intermediate
    secrets                 = local.secrets
    zone_name               = each.key
    instance_type           = "worker"
    }
  )
}
