resource "vault_policy" "kubernetes-sign-approle" {
  for_each  = local.issuers_content_map_only

  name      = "clusters/${var.cluster_name}/certificates/${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("${path.module}/templates/vault/vault-certificate-sign-role.tftpl", { 
    intermediate          = var.k8s_certificate_vars.ssl.intermediate[split(":","${each.key}")[0]]
    cluster_name          = var.cluster_name
    issuer_name           = split(":","${each.key}")[1]
    }
  )
}
