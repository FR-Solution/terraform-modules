resource "vault_policy" "kubernetes-bootstrap-master" {

  name      = "${var.k8s_global_vars.main_path.base_vault_path}/bootstrap-master"

  policy = templatefile("${path.module}/templates/vault/vault-bootstarp-approle-all.tftpl", { 
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle
    intermediates           = var.k8s_global_vars.ssl.intermediate
    external_intermediates  = var.k8s_global_vars.ssl.external_intermediate
    secrets                 = var.k8s_global_vars.secrets
    instance_type           = "master"
    }
  )
}
