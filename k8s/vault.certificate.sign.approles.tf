resource "vault_approle_auth_backend_role" "kubernetes-sign-master" {
  for_each                = local.issuers_content_map_master
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s", split(":",each.key)[1],split(":",each.key)[2])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-sign-approle[format("%s:%s", split(":",each.key)[0],split(":",each.key)[1])].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

resource "vault_approle_auth_backend_role" "kubernetes-sign-worker" {
  for_each                = local.issuers_content_map_worker
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s", split(":",each.key)[1],split(":",each.key)[2])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-sign-approle[format("%s:%s", split(":",each.key)[0],split(":",each.key)[1])].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
