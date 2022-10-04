resource "vault_approle_auth_backend_role" "kubernetes-sign" {
  for_each                = local.issuers_content_map
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s", split(":",each.key)[1],split(":",each.key)[2])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-sign[format("%s:%s", split(":",each.key)[0],split(":",each.key)[1])].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []

}
