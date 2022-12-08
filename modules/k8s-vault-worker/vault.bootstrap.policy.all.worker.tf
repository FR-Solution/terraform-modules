
resource "vault_policy" "kubernetes-all-bootstrap-worker" {
  for_each  = var.worker_instance_list_map

  name      = "${var.k8s_global_vars.global_path.base_vault_path}/bootstrap-all-${each.key}"

  policy = templatefile("${path.module}/templates/vault/vault-bootstarp-approle-all.tftpl", { 
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle
    intermediates           = var.k8s_global_vars.ssl.intermediate
    external_intermediates  = var.k8s_global_vars.ssl.external_intermediate
    secrets                 = var.k8s_global_vars.secrets
    zone_name               = each.key
    instance_type           = "worker"
    }
  )
}
