terraform {

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.6.0"
    }

  }
  required_version = ">= 0.13"
}
