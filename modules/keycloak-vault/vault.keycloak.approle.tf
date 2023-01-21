resource "vault_auth_backend" "auth" {
  type = "approle"
  path = "${var.root_ca_path}/keycloak/approle"
}

resource "vault_approle_auth_backend_role" "auth" {
  backend                 = "${vault_auth_backend.auth.path}"
  role_name               = "keycloak"
  token_policies          = local.policy_name_list
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
