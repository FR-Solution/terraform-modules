
resource "vault_mount" "root_ca" {
  for_each                      = var.k8s_global_vars.ssl_for_each_map.root_ca_default_map_only

  allowed_managed_keys          = each.value.mount.allowed_managed_keys
  audit_non_hmac_request_keys   = each.value.mount.audit_non_hmac_request_keys
  audit_non_hmac_response_keys  = each.value.mount.audit_non_hmac_response_keys
  options                       = each.value.mount.options
  external_entropy_access       = each.value.mount.external_entropy_access
  seal_wrap                     = each.value.mount.seal_wrap
  local                         = each.value.mount.local
  max_lease_ttl_seconds         = each.value.mount.max_lease_ttl_seconds
  default_lease_ttl_seconds     = each.value.mount.default_lease_ttl_seconds
  description                   = each.value.mount.description
  type                          = each.value.mount.mount_type
  path                          = each.value.default.path
}

resource "vault_mount" "intermediate" {
  for_each                      = var.k8s_global_vars.ssl_for_each_map.intermediate_ca_default_map_only
  
  allowed_managed_keys          = each.value.mount.allowed_managed_keys
  audit_non_hmac_request_keys   = each.value.mount.audit_non_hmac_request_keys
  audit_non_hmac_response_keys  = each.value.mount.audit_non_hmac_response_keys
  options                       = each.value.mount.options
  external_entropy_access       = each.value.mount.external_entropy_access
  seal_wrap                     = each.value.mount.seal_wrap
  local                         = each.value.mount.local
  max_lease_ttl_seconds         = each.value.mount.max_lease_ttl_seconds
  default_lease_ttl_seconds     = each.value.mount.default_lease_ttl_seconds
  description                   = each.value.mount.description
  type                          = each.value.mount.mount_type
  path                          = each.value.path
}

resource "vault_mount" "kubernetes-secrets" {
  path        = var.k8s_global_vars.global_path.base_vault_path_kv
  type        = "kv-v2"
  description = "KV Version 2 for K8S CP secrets"
  options     = {}
}

