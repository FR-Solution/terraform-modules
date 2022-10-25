resource "vault_pki_secret_backend_role" "kubernetes-role" {
    depends_on = [vault_mount.intermediate]
    
    for_each                            = var.k8s_global_vars.ssl_for_each_map.issuers_content_map_only
    
    backend                             = var.k8s_global_vars.ssl.intermediate[split(":","${each.key}")[0]].path
    name                                = split(":","${each.key}")[1]

    allow_any_name                      = each.value.allow_any_name
    allow_bare_domains                  = each.value.allow_bare_domains
    allow_glob_domains                  = each.value.allow_glob_domains
    allow_ip_sans                       = each.value.allow_ip_sans
    allow_localhost                     = each.value.allow_localhost
    allow_subdomains                    = each.value.allow_subdomains
    allowed_domains_template            = each.value.allowed_domains_template
    allowed_domains                     = each.value.allowed_domains
    allowed_other_sans                  = each.value.allowed_other_sans
    allowed_serial_numbers              = each.value.allowed_serial_numbers
    allowed_uri_sans                    = each.value.allowed_uri_sans
    basic_constraints_valid_for_non_ca  = each.value.basic_constraints_valid_for_non_ca
    client_flag                         = each.value.client_flag
    server_flag                         = each.value.server_flag
    code_signing_flag                   = each.value.code_signing_flag
    email_protection_flag               = each.value.email_protection_flag
    enforce_hostnames                   = each.value.enforce_hostnames
    generate_lease                      = each.value.generate_lease
    key_bits                            = each.value.key_bits
    key_type                            = each.value.key_type
    key_usage                           = each.value.key_usage
    ext_key_usage                       = each.value.ext_key_usage
    no_store                            = each.value.no_store
    require_cn                          = each.value.require_cn
    ttl                                 = each.value.ttl
    use_csr_common_name                 = each.value.use_csr_common_name
    organization                        = each.value.organization
    country                             = each.value.country
    locality                            = each.value.locality
    ou                                  = each.value.ou
    postal_code                         = each.value.postal_code
    province                            = each.value.province
    street_address                      = each.value.street_address
}
