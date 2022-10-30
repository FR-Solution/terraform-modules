resource "vault_auth_backend" "approle" {
  type = "approle"
  path = var.k8s_global_vars.global_path.base_vault_path_approle
}