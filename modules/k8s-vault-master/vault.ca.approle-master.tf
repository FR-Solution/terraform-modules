resource "vault_approle_auth_backend_role" "kubernetes-ca-master" {
  for_each                = local.intermediate_content_map_master
  backend                 = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-ca-approle-master[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

resource "vault_approle_auth_backend_role" "external-ca-master" {
  for_each                = local.external_intermediate_content_map_master
  backend                 = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name               = format("%s-%s",split(":","${each.key}")[0],split(":","${each.key}")[1])
  token_ttl               = 60
  token_policies          = [vault_policy.external-ca-approle-master[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}


resource "vault_approle_auth_backend_role_secret_id" "external-ca-master" {
  for_each  = local.external_intermediate_content_map_master
  backend   = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name = vault_approle_auth_backend_role.external-ca-master[each.key].role_name
}

resource "vault_approle_auth_backend_role_secret_id" "kubernetes-ca-master" {
  for_each  = local.intermediate_content_map_master
  backend   = var.k8s_global_vars.global_path.base_vault_path_approle
  role_name = vault_approle_auth_backend_role.kubernetes-ca-master[each.key].role_name
}
