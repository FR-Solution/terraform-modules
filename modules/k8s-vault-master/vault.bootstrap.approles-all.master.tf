resource "vault_approle_auth_backend_role" "all_masters" {
  for_each  = var.k8s_global_vars.master_vars.master_instance_list_map

  backend                 = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name               = each.key
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-bootstrap-master.name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []

}

resource "vault_approle_auth_backend_role_secret_id" "all_masters" {
  count = try(var.vault_approle_auth_backend_role_secret_id.enabled, false) == true ? 1 : 0

  for_each  = var.k8s_global_vars.master_vars.master_instance_list_map
  backend   = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name = vault_approle_auth_backend_role.all_masters[each.key].role_name
}
