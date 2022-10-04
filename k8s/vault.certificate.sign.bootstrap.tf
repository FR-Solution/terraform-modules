resource "vault_token_auth_backend_role" "kubernetes-sign" {
  for_each                  = local.issuers_content_map_only
  role_name                 = format("%s-%s",split(":","${each.key}")[1], var.cluster_name)
  allowed_policies          = [vault_policy.kubernetes-sign-bootstrap[format("%s:%s", split(":","${each.key}")[0],split(":","${each.key}")[1])].name]
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

  lifecycle {
    ignore_changes = [

    ]
  }
}

resource "vault_token" "kubernetes-sign-login" {
  for_each  = local.issuers_content_map
  role_name = vault_token_auth_backend_role.kubernetes-sign[format("%s:%s", split(":","${each.key}")[0],split(":","${each.key}")[1])].role_name
  policies  = vault_token_auth_backend_role.kubernetes-sign[format("%s:%s", split(":","${each.key}")[0],split(":","${each.key}")[1])].allowed_policies
  metadata  = {}
  ttl = "5m"

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}
