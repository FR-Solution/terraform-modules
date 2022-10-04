resource "vault_token" "kubernetes-kv-login" {
  for_each  = local.secret_content_map
  role_name = "${vault_token_auth_backend_role.kubernetes-kv[split(":",each.key)[0]].role_name}"
  policies  = "${vault_token_auth_backend_role.kubernetes-kv[split(":",each.key)[0]].allowed_policies}"
  metadata  = {}
  ttl = "10m"
}

resource "vault_token_auth_backend_role" "kubernetes-kv" {
  for_each                  = local.secret_content_map_only

  role_name                 = each.key
  allowed_policies          = [vault_policy.kubernetes-kv-bootstrap[each.key].name]
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