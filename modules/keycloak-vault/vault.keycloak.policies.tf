resource "vault_policy" "auth" {
  name      = "pki-int/keycloak"

  policy = file("${path.module}/templates/keycloak-policy.tftpl")
}
