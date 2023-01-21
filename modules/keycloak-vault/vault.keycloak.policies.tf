resource "vault_policy" "auth" {
  name      = "${var.root_ca_path}/keycloak"

  policy = file("${path.module}/templates/keycloak-policy.tftpl")
}
