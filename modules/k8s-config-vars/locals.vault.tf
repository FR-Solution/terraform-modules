locals {
  vault-config = {
    vault_server            = try(var.extra_args.vault_server,          null) == null ? "vault.ru" : var.extra_args.vault_server
    vault_server_insecure   = try(var.extra_args.vault_server_insecure, null) == null ? true       : var.extra_args.vault_server_insecure
    caBundle                = try(var.extra_args.ca_bundle_path,        null) == null ? ""         : var.extra_args.ca_bundle_path
  }
} 