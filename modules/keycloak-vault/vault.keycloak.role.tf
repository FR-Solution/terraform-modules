resource "vault_pki_secret_backend_role" "keycloak-server" {
    for_each                            = local.certificates

    backend                             = var.root_ca_path
    name                                = each.key

    allow_any_name                      = try(local.certificates[each.key].allow_any_name,                      null)   == null ?  false    : local.certificates[each.key].allow_any_name
    allow_bare_domains                  = try(local.certificates[each.key].allow_bare_domains,                  null)   == null ?  false    : local.certificates[each.key].allow_bare_domains
    allow_glob_domains                  = try(local.certificates[each.key].allow_glob_domains,                  null)   == null ?  false    : local.certificates[each.key].allow_glob_domains
    allow_subdomains                    = try(local.certificates[each.key].allow_subdomains,                    null)   == null ?  false    : local.certificates[each.key].allow_subdomains
    allowed_domains_template            = try(local.certificates[each.key].allowed_domains_template,            null)   == null ?  false    : local.certificates[each.key].allowed_domains_template
    basic_constraints_valid_for_non_ca  = try(local.certificates[each.key].basic_constraints_valid_for_non_ca,  null)   == null ?  false    : local.certificates[each.key].basic_constraints_valid_for_non_ca
    code_signing_flag                   = try(local.certificates[each.key].code_signing_flag,                   null)   == null ?  false    : local.certificates[each.key].code_signing_flag
    email_protection_flag               = try(local.certificates[each.key].email_protection_flag,               null)   == null ?  false    : local.certificates[each.key].email_protection_flag
    enforce_hostnames                   = try(local.certificates[each.key].enforce_hostnames,                   null)   == null ?  false    : local.certificates[each.key].enforce_hostnames
    generate_lease                      = try(local.certificates[each.key].generate_lease,                      null)   == null ?  false    : local.certificates[each.key].generate_lease
    allow_ip_sans                       = try(local.certificates[each.key].allow_ip_sans,                       null)   == null ?  false    : local.certificates[each.key].allow_ip_sans
    allow_localhost                     = try(local.certificates[each.key].allow_localhost,                     null)   == null ?  false    : local.certificates[each.key].allow_localhost
    client_flag                         = try(local.certificates[each.key].client_flag,                         null)   == null ?  false    : local.certificates[each.key].client_flag
    server_flag                         = try(local.certificates[each.key].server_flag,                         null)   == null ?  false    : local.certificates[each.key].server_flag
    key_bits                            = try(local.certificates[each.key].key_bits,                            null)   == null ?  4096     : local.certificates[each.key].key_bits
    key_type                            = try(local.certificates[each.key].key_type,                            null)   == null ?  "rsa"    : local.certificates[each.key].key_type
    key_usage                           = try(local.certificates[each.key].key_usage,                           null)   == null ?  []       : local.certificates[each.key].key_usage
    organization                        = try(local.certificates[each.key].organization,                        null)   == null ?  []       : local.certificates[each.key].organization
    country                             = try(local.certificates[each.key].country,                             null)   == null ?  []       : local.certificates[each.key].country
    locality                            = try(local.certificates[each.key].locality,                            null)   == null ?  []       : local.certificates[each.key].locality
    ou                                  = try(local.certificates[each.key].ou,                                  null)   == null ?  []       : local.certificates[each.key].ou
    postal_code                         = try(local.certificates[each.key].postal_code,                         null)   == null ?  []       : local.certificates[each.key].postal_code
    province                            = try(local.certificates[each.key].province,                            null)   == null ?  []       : local.certificates[each.key].province
    street_address                      = try(local.certificates[each.key].street_address,                      null)   == null ?  []       : local.certificates[each.key].street_address
    allowed_domains                     = try(local.certificates[each.key].allowed_domains,                     null)   == null ?  []       : local.certificates[each.key].allowed_domains
    allowed_other_sans                  = try(local.certificates[each.key].allowed_other_sans,                  null)   == null ?  []       : local.certificates[each.key].allowed_other_sans
    allowed_serial_numbers              = try(local.certificates[each.key].allowed_serial_numbers,              null)   == null ?  []       : local.certificates[each.key].allowed_serial_numbers
    allowed_uri_sans                    = try(local.certificates[each.key].allowed_uri_sans,                    null)   == null ?  []       : local.certificates[each.key].allowed_uri_sans
    ext_key_usage                       = try(local.certificates[each.key].ext_key_usage,                       null)   == null ?  []       : local.certificates[each.key].ext_key_usage
    no_store                            = try(local.certificates[each.key].no_store,                            null)   == null ?  false    : local.certificates[each.key].no_store
    require_cn                          = try(local.certificates[each.key].require_cn,                          null)   == null ?  false    : local.certificates[each.key].require_cn
    ttl                                 = try(local.certificates[each.key].ttl,                                 null)   == null ?  31540000 : local.certificates[each.key].ttl
    use_csr_common_name                 = try(local.certificates[each.key].use_csr_common_name,                 null)   == null ?  false    : local.certificates[each.key].use_csr_common_name

}
