resource "vault_approle_auth_backend_role" "kubernetes-kv" {
  for_each                = var.k8s_global_vars.ssl_for_each_map.secret_content_map

  backend                 = vault_auth_backend.approle.path
  role_name               = format("%s-%s", split(":",each.key)[0], split(":",each.key)[1])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-kv-approle[split(":",each.key)[0]].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []

}
