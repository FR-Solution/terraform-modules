resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "${local.base_vault_path_approle}"
}