resource "vault_policy" "kubernetes-sign-approle" {
  for_each  = local.issuers_content_map_only

  name      = "clusters/${var.cluster_name}/certificates/${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("templates/vault/vault-certificate-sign-role.tftpl", { 
    intermediate          = local.ssl.intermediate[split(":","${each.key}")[0]]
    cluster_name          = var.cluster_name
    issuer_name           = split(":","${each.key}")[1]
    }
  )
}
