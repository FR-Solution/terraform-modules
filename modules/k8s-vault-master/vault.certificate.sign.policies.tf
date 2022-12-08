resource "vault_policy" "kubernetes-sign-approle" {
  for_each  = local.issuers_content_map_only

  name      = "${var.k8s_global_vars.global_path.base_vault_path}/certificates/cp-${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("${path.module}/templates/vault/vault-certificate-sign-role.tftpl", { 
    intermediate            = var.k8s_global_vars.ssl.intermediate[split(":","${each.key}")[0]]
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle,
    issuer_name             = split(":","${each.key}")[1]
    }
  )
}
