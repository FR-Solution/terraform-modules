resource "vault_auth_backend" "auth" {
  type = "approle"
  path = "pki-root/approle"
}

resource "vault_approle_auth_backend_role" "auth" {
  backend                 = "${vault_auth_backend.auth.path}"
  role_name               = "keycloak"
  token_policies          = [vault_policy.auth.name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
