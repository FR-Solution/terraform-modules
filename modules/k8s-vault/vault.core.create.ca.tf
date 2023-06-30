
##### K8S INTERMEDIATE ROOT #####################
### ->
resource "vault_pki_secret_backend_root_cert" "root" {

  for_each                = var.k8s_global_vars.ssl_for_each_map.root_ca_default_map_only

  backend                 = vault_mount.root_ca[each.key].path
  
  common_name             = each.value.common_name
  type                    = each.value.type
  format                  = each.value.format
  private_key_format      = each.value.private_key_format
  key_type                = each.value.key_type
  key_bits                = each.value.key_bits
  exclude_cn_from_sans    = each.value.exclude_cn_from_sans
  ou                      = each.value.ou
  organization            = each.value.organization
  country                 = each.value.country
  locality                = each.value.locality 
  province                = each.value.province
  street_address          = each.value.street_address
  postal_code             = each.value.postal_code
  alt_names               = each.value.alt_names
  ip_sans                 = each.value.ip_sans
  uri_sans                = each.value.uri_sans
  other_sans              = each.value.other_sans
  ttl                     = each.value.ttl 
  max_path_length         = each.value.max_path_length 
  permitted_dns_domains   = each.value.permitted_dns_domains 

}

##### K8S INTERMEDIATE #####################
### ->
resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  depends_on  = [
    vault_pki_secret_backend_root_cert.root
  ]

  for_each                = var.k8s_global_vars.ssl_for_each_map.intermediate_ca_default_map_only

  backend                 = vault_mount.intermediate[each.key].path
  
  common_name             = each.value.common_name
  type                    = each.value.type
  format                  = each.value.format
  private_key_format      = each.value.private_key_format
  key_type                = each.value.key_type
  key_bits                = each.value.key_bits
  exclude_cn_from_sans    = each.value.exclude_cn_from_sans
  ou                      = each.value.ou
  organization            = each.value.organization
  country                 = each.value.country
  locality                = each.value.locality 
  province                = each.value.province
  street_address          = each.value.street_address
  postal_code             = each.value.postal_code
  alt_names               = each.value.alt_names
  ip_sans                 = each.value.ip_sans
  uri_sans                = each.value.uri_sans
  other_sans              = each.value.other_sans
  add_basic_constraints   = each.value.add_basic_constraints

}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  for_each      = var.k8s_global_vars.ssl_for_each_map.intermediate_ca_default_map_only
  backend       = each.value.root_path
  csr           = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].csr
  common_name   = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].common_name
  revoke        = each.value.sign.revoke
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  for_each    = var.k8s_global_vars.ssl.intermediate
  backend     = vault_mount.intermediate[each.key].path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate[each.key].certificate
}
