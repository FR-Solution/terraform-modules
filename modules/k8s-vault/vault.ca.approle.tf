resource "vault_approle_auth_backend_role" "kubernetes-ca" {
  for_each                = local.intermediate_content_map
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-ca-approle[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}


resource "vault_approle_auth_backend_role" "external-ca" {
  for_each                = local.external_intermediate_content_map
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.external-ca-approle[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

