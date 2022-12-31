
resource "vault_mount" "root_ca" {
  for_each                  = var.k8s_global_vars.ssl.root_ca
  path                      = each.value.path
  type                      = "pki"
  description               = "intermediate"
  default_lease_ttl_seconds = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds     = each.value.max_lease_ttl_seconds
  options                   = {}
}

resource "vault_mount" "intermediate" {
  for_each                  = var.k8s_global_vars.ssl.intermediate
  path                      = each.value.path
  type                      = "pki"
  description               = "intermediate"
  default_lease_ttl_seconds = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds     = each.value.max_lease_ttl_seconds
  options                   = {}
}

resource "vault_mount" "kubernetes-secrets" {
  path        = var.k8s_global_vars.global_path.base_vault_path_kv
  type        = "kv-v2"
  description = "KV Version 2 for K8S CP secrets"
  options     = {}
}
