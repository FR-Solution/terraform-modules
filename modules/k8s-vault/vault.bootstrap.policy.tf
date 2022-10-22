resource "vault_policy" "kubernetes-all-bootstrap-master" {
  for_each  = local.master_instance_list_map

  name      = "clusters/${var.cluster_name}/bootstrap-all-${each.key}"

  policy = templatefile("../../modules/k8s-vault/templates/vault/vault-bootstarp-approle-all.tftpl", { 
    cluster_name            = var.cluster_name
    intermediates           = var.k8s_certificate_vars.ssl.intermediate
    external_intermediates  = var.k8s_certificate_vars.ssl.external_intermediate
    secrets                 = var.k8s_certificate_vars.secrets
    zone_name               = each.key
    instance_type           = "master"
    }
  )
}

resource "vault_policy" "kubernetes-all-bootstrap-worker" {
  for_each  = local.worker_instance_list_map

  name      = "clusters/${var.cluster_name}/bootstrap-all-${each.key}"

  policy = templatefile("../../modules/k8s-vault/templates/vault/vault-bootstarp-approle-all.tftpl", { 
    cluster_name            = var.cluster_name
    intermediates           = var.k8s_certificate_vars.ssl.intermediate
    external_intermediates  = var.k8s_certificate_vars.ssl.external_intermediate
    secrets                 = var.k8s_certificate_vars.secrets
    zone_name               = each.key
    instance_type           = "worker"
    }
  )
}
