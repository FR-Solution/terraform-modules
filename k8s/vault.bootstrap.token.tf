resource "vault_token_auth_backend_role" "kubernetes-all-bootstrap" {
  for_each                  = local.master_instance_list_map
  role_name                 = "all-${each.key}"
  allowed_policies          = [vault_policy.kubernetes-all-bootstrap[each.key].name]
  token_period              = "300"
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

resource "vault_token" "kubernetes-all-login-bootstrap" {
  for_each  = local.master_instance_list_map
  role_name = vault_token_auth_backend_role.kubernetes-all-bootstrap[each.key].role_name
  policies  = vault_token_auth_backend_role.kubernetes-all-bootstrap[each.key].allowed_policies
  metadata  = {}
  ttl = "5m"
  # num_uses = 1
}
