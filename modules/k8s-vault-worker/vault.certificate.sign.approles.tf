
resource "vault_approle_auth_backend_role" "kubernetes-sign-worker" {
  for_each                = local.issuers_content_map_worker
  backend                 = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name               = format("%s-%s", split(":",each.key)[1],split(":",each.key)[2])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-sign-approle[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
