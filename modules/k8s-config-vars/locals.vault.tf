locals {
  vault-config = {
    vault_server            = var.vault_server
    vault_server_insecure   = var.vault_server_insecure
    caBundle                = var.caBundle
  }
} 