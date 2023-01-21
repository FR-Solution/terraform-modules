resource "vault_policy" "auth" {
  for_each  = local.certificates
  name      = "${var.root_ca_path}/${each.key}"

  policy = templatefile("${path.module}/templates/keycloak-policy.tftpl", {
    pki_path          = var.root_ca_path
    certificate_role  = each.key
  })
}
