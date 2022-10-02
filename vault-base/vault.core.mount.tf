resource "vault_mount" "core_root_ca" {
  path                      = "pki-root"
  type                      = "pki"
  description               = "root infrastruction"
  default_lease_ttl_seconds = 321408000
  max_lease_ttl_seconds     = 321408000
}
resource "vault_pki_secret_backend_root_cert" "core_root" {
  backend              = vault_mount.core_root_ca.path
  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = 321408000
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  province             = "CA"
}


resource "vault_policy" "auth" {
  name      = "pki-int/keycloak"

  policy = templatefile("templates/keycloak-policy.tftpl", { })
}

resource "vault_auth_backend" "auth" {
  type = "approle"
  path = "pki-root/approle"
}

resource "vault_approle_auth_backend_role" "auth" {
  backend                 = "${vault_auth_backend.auth.path}"
  role_name               = "keycloak"
  token_policies          = [vault_policy.auth.name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}



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

resource "yandex_dns_recordset" "auth" {
  zone_id = "dns140h7j2l3gcjchb1v"
  name    = "auth.dobry-kot.ru"
  type    = "A"
  ttl     = 60
  data    = ["193.32.219.99"]
}