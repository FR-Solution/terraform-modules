resource "vault_pki_secret_backend_role" "keycloak-server" {

    backend                             = vault_mount.core_root_ca.path

    name                                = "keycloak-server"

    allow_any_name                      = false
    allow_bare_domains                  = true
    allow_glob_domains                  = true
    allow_subdomains                    = false
    allowed_domains_template            = true
    basic_constraints_valid_for_non_ca  = false
    code_signing_flag                   = false
    email_protection_flag               = false
    enforce_hostnames                   = false
    generate_lease                      = false
    allow_ip_sans                       = true
    allow_localhost                     = true
    client_flag                         = false
    server_flag                         = true
    key_bits                            = 4096
    key_type                            = "rsa"
    key_usage                           = []
    organization                        = []
    country                             = []
    locality                            = []
    ou                                  = []
    postal_code                         = []
    province                            = []
    street_address                      = []
    allowed_domains                     = ["custom:keycloak-server", "auth.dobry-kot.ru", "localhost"]
    allowed_other_sans                  = []
    allowed_serial_numbers              = []
    allowed_uri_sans                    = []
    ext_key_usage                       = []
    no_store                            = false
    require_cn                          = false
    ttl                                 = 31540000
    use_csr_common_name                 = true
        
}

