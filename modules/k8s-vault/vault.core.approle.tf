resource "vault_auth_backend" "approle" {
  type = "approle"
  path = var.k8s_certificate_vars.base_vault_path_approle
}