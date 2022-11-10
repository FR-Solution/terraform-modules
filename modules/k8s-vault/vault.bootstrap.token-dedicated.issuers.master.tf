

resource "vault_token_auth_backend_role" "kubernetes-dedicated-issuer-bootstrap-master" {
  for_each                  = var.k8s_global_vars.ssl_for_each_map.issuers_content_map_master

  role_name                 = "${join(".",split(":", each.key))}"
  allowed_policies          = [vault_policy.kubernetes-dedicated-issuer-bootstrap-master[each.key].name]
  token_period              = "0"
  renewable                 = false
  allowed_entity_aliases    = []
  allowed_policies_glob     = []
  disallowed_policies       = []
  disallowed_policies_glob  = []
  token_bound_cidrs         = []
  token_policies            = []
  orphan                    = false
  token_type                = "default-service"
}

resource "vault_token" "kubernetes-dedicated-issuer-login-bootstrap-master" {
  for_each  = var.k8s_global_vars.ssl_for_each_map.issuers_content_map_master
  role_name = vault_token_auth_backend_role.kubernetes-dedicated-issuer-bootstrap-master[each.key].role_name
  policies  = vault_token_auth_backend_role.kubernetes-dedicated-issuer-bootstrap-master[each.key].allowed_policies
  metadata  = {}
  ttl       = 300
  num_uses  = 2
  # TODO ждем фикса key-keeper
  # num_uses  = 1

}
