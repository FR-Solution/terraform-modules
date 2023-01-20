terraform {

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.6.0"
    }

  }
  required_version = ">= 0.13"
}


provider "vault" {
    address = var.vault.key.address
    token   = var.vault.key.token
}

provider "keycloak" {
  realm                    = var.keycloak.key.realm
  client_id                = var.keycloak.key.client_id
  username                 = var.keycloak.key.username
  password                 = var.keycloak.key.password
  url                      = var.keycloak.key.url
  root_ca_certificate      = var.keycloak.key.root_ca_certificate
  tls_insecure_skip_verify = var.keycloak.key.tls_insecure_skip_verify
}

