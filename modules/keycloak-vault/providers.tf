terraform {

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.12.0"
    }
  }
  required_version = ">= 0.13"
}
