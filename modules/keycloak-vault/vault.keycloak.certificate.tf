locals {
  idp_provider_realm = "master"

  certificates = {
    keycloak-server = {
      allow_bare_domains        = true
      allow_glob_domains        = true
      allowed_domains_template  = true
      allow_ip_sans             = true
      allow_localhost           = true
      server_flag               = true
      use_csr_common_name       = true
      allowed_domains           = [
        var.external_keycloak_url,
        "custom:keycloak-server", 
        "localhost", 
      ]
    }
  }

}
