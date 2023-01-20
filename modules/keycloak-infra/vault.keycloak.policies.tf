resource "vault_policy" "auth" {
  name      = "pki-int/keycloak"

  policy = file("templates/keycloak-policy.tftpl")
}
