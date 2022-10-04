resource "vault_token_auth_backend_role" "kubernetes-ca" {
  for_each                  = local.intermediate_content_map_only
  role_name                 = "${split(":","${each.key}")[0]}"
  allowed_policies          = [vault_policy.kubernetes-ca-bootstrap[each.key].name]
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

resource "vault_token" "kubernetes-ca-login" {
  for_each  = local.intermediate_content_map
  role_name = vault_token_auth_backend_role.kubernetes-ca[format("%s:%s", split(":","${each.key}")[0],split(":","${each.key}")[1])].role_name
  policies  = vault_token_auth_backend_role.kubernetes-ca[format("%s:%s", split(":","${each.key}")[0],split(":","${each.key}")[1])].allowed_policies
  metadata  = {}
  ttl = "10m"
}
