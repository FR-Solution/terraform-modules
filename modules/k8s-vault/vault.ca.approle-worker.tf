resource "vault_approle_auth_backend_role" "kubernetes-ca-worker" {
  for_each                = var.k8s_global_vars.ssl_for_each_map.intermediate_content_map_worker
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-ca-approle-worker[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}


resource "vault_approle_auth_backend_role" "external-ca-worker" {
  for_each                = var.k8s_global_vars.ssl_for_each_map.external_intermediate_content_map_worker
  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.external-ca-approle-worker[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
