resource "vault_approle_auth_backend_role" "kubernetes-kv" {
  for_each                = local.secret_content_map

  backend                 = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name               = format("%s-%s", split(":",each.key)[0], split(":",each.key)[1])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-kv-approle[split(":",each.key)[0]].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []

}

resource "vault_approle_auth_backend_role_secret_id" "kubernetes-kv" {
  for_each  = local.secret_content_map
  backend   = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name = vault_approle_auth_backend_role.kubernetes-kv[each.key].role_name
}
